import json
import math
import re

from os.path import expanduser
from itertools import islice
from typing import List, Dict, Any
from kitty.boss import Boss
from kitty.remote_control import create_basic_command, encode_send
from kitty.typing import KeyEventType
from kitty.fast_data_types import current_focused_os_window_id
from kitty.key_encoding import RELEASE
from kittens.tui.handler import Handler
from kittens.tui.loop import Loop
from kittens.tui.operations import styled, repeat


class SessionSwitcher(Handler):
    def __init__(self):
        self.session_names = {}
        self.os_windows = []
        self.selected_session_idx = None
        self.cmds = []
        self.windows_text = {}

    def initialize(self) -> None:
        self.cmd.set_cursor_visible(False)
        self.draw_screen()
        ls = create_basic_command("ls", no_response=False)
        self.write(encode_send(ls))
        self.cmds.append({"type": "ls"})
        try:
            with open(f"{expanduser('~')}/.kitty-sessions.json") as f:
                self.session_names = json.loads(f.read())
        except:
            self.session_names = {}

    # this assumes that communication via kitty cmds in synchronous...
    def on_kitty_cmd_response(self, response: Dict[str, Any]) -> None:
        cmd = self.cmds.pop()
        if cmd["type"] == "ls":
            os_windows = json.loads(response["data"])
            self.os_windows = os_windows
            active_windows = next(w for w in os_windows if w["is_active"])
            self.selected_session_idx = os_windows.index(active_windows)
            cmds = []
            for os_window in os_windows:
                for tab in os_window["tabs"]:
                    for w in tab["windows"]:
                        wid = w["id"]
                        get_text = create_basic_command(
                            "get-text",
                            {"match": f"id:{wid}", "ansi": True},
                            no_response=False,
                        )
                        self.write(encode_send(get_text))
                        self.cmds.insert(
                            0,
                            {
                                "type": "get-text",
                                "os_window_id": os_window["id"],
                                "tab_id": tab["id"],
                                "window_id": wid,
                            },
                        )
            self.cmds = self.cmds + cmds
            self.draw_screen()

        if cmd["type"] == "get-text":
            # replace tabs with two spaces because having a character that spans multiple columns messes up computations
            lines = [
                Ansi(f"{line}")
                for line in response["data"].replace("\t", "  ").split("\n")
            ]
            self.windows_text[cmd["window_id"]] = lines
            self.draw_screen()

    def on_key_event(
        self, key_event: KeyEventType, in_bracketed_paste: bool = False
    ) -> None:
        if key_event.type == RELEASE:
            return

        if key_event.matches("esc"):
            self.quit_loop(0)

        if key_event.matches("enter"):
            tab = next(
                t
                for t in self.os_windows[self.selected_session_idx]["tabs"]
                if t["is_active"]
            )
            window_id = next(w for w in tab["windows"] if w["is_active"])["id"]
            focus_window = create_basic_command(
                "focus_window", {"match": f"id:{window_id}"}, no_response=True
            )
            self.write(encode_send(focus_window))
            self.quit_loop(0)

        if key_event.key == "j":
            self.selected_session_idx = (self.selected_session_idx + 1) % len(
                self.os_windows
            )
            self.draw_screen()

        if key_event.key == "k":
            self.selected_session_idx = (
                self.selected_session_idx + -1 + len(self.os_windows)
            ) % len(self.os_windows)
            self.draw_screen()

    def draw_screen(self) -> None:
        self.cmd.clear_screen()
        print = self.print
        if not self.os_windows:
            return
        for i, os_window in enumerate(self.os_windows):
            wid = os_window["id"]
            session_name = f" {self.session_names.get(str(wid), i)} "
            if os_window["is_active"]:
                session_name = f"➜{session_name}"
            if i == self.selected_session_idx:
                print(styled(session_name, bg="green", fg="black"))
            else:
                print(session_name)

        # don't draw anything if we have nothing to show, otherwise we can see the borders for
        # a couple of ms. this is an approximation since we might get some text data for another
        # window than the one we're showing, but it seems to do the job.
        if not self.windows_text:
            return

        tabs = list(islice(self.os_windows[self.selected_session_idx]["tabs"], 0, 4))
        tab_height = math.floor(self.screen_size.rows / 2 - 2)

        for _ in range(
            self.screen_size.rows - len(self.os_windows) - tab_height - 2 - 1
        ):  # 2 for borders, 1 for the tab_bar
            print("")

        def print_horizontal_border(
            left_corner: str, middle_corner: str, right_corner: str
        ):
            border = left_corner
            for idx, tab in enumerate(tabs):
                width = tab_width(self.screen_size.cols, len(tabs), idx)
                border += repeat("─", width)
                if idx < len(tabs) - 1:
                    border += middle_corner
                else:
                    border += right_corner
            print(border)

        print_horizontal_border("┌", "┬", "┐")

        # messy code for tab preview display
        lines_by_tab = []
        for idx, tab in enumerate(tabs):
            new_line = []
            w = tab["windows"][0]
            lines = self.windows_text.get(w["id"], "")
            width = tab_width(self.screen_size.cols, len(tabs), idx)
            for line in islice(lines, 0, tab_height):
                new_line.append(line.slice(width - 2).ljust(width - 2))
            lines_by_tab.append(new_line)

        for line in zip(*lines_by_tab):
            print(
                "│ " + "\x1b[0m │ ".join([l.get_raw_text() for l in line]) + " \x1b[0m│"
            )

        print_horizontal_border("└", "┴", "┘")


# Ansi escaping mostly stolen from
# https://github.com/getcuia/stransi/blob/main/src/stransi/

PATTERN = re.compile(r"(\N{ESC}\[[\d;|:]*[a-zA-Z]|\N{ESC}\]133;[A-Z]\N{ESC}\\)")
# ansi--^     shell prompt OSC 133--^


class Ansi:
    def __init__(self, text):
        self.raw_text = text
        self.parsed = list(parse_ansi_colors(self.raw_text))

    def __str__(self):
        return f"Ansi({[str(c) for c in self.parsed]}, {self.raw_text})"

    def get_raw_text(self):
        return self.raw_text

    def slice(self, n):
        chars = 0
        text = ""
        for token in self.parsed:
            if isinstance(token, EscapeSequence):
                text += token.get_sequence()
            else:
                sliced = token[: n - chars]
                text += sliced
                chars += len(sliced)
        return Ansi(text)

    def ljust(self, n):
        chars = 0
        text = ""
        for token in self.parsed:
            if isinstance(token, EscapeSequence):
                text += token.get_sequence()
            else:
                text += token
                chars += len(token)
        for i in range(0, n - chars):
            text += " "
        return Ansi(text)


class EscapeSequence:
    def __init__(self, sequence: str):
        self.sequence = sequence

    def __str__(self):
        return f"EscapeSequence({self.sequence})"

    def get_sequence(self):
        return self.sequence


def parse_ansi_colors(text: str):
    prev_end = 0
    for match in re.finditer(PATTERN, text):
        # Yield the text before escape sequence.
        yield text[prev_end : match.start()]

        if escape_sequence := match.group(0):
            yield EscapeSequence(escape_sequence)

        # Update the start position.
        prev_end = match.end()

    # Yield the text after the last escape sequence.
    yield text[prev_end:]


# the last tab must sometimes be padded by 1 column so that the preview fits the whole width
def tab_width(cols, tab_count, idx):
    border_count = tab_count + 1
    tab_width = math.floor((cols - border_count) / tab_count)
    if tab_count == 1:
        return tab_width
    if idx == tab_count - 1 and tab_count % 2 == cols % 2:
        return tab_width + 1
    else:
        return tab_width


def main(args: List[str]) -> str:
    loop = Loop()
    handler = SessionSwitcher()
    loop.loop(handler)
