import json
import os

from os.path import expanduser, basename
from typing import List
from kitty.boss import Boss
from kittens.tui.operations import styled
from kitty.fast_data_types import current_focused_os_window_id


def main(args: List[str]) -> str:
    # this is the main entry point of the kitten, it will be executed in
    # the overlay window when the kitten is launched
    default = basename(os.environ["PWD"])
    print(styled("Enter the new title for this session below.", bold=True))
    answer = input(f"({default}) > ")
    # whatever this function returns will be available in the
    # handle_result() function
    return answer or default


def handle_result(
    args: List[str], answer: str, target_window_id: int, boss: Boss
) -> None:
    fn = f"{expanduser('~')}/.kitty-sessions.json"
    if not os.path.exists(fn):
        with open(fn, "w") as f:
            f.write("{}")
    with open(fn) as f:
        session_names = json.loads(f.read())
        session_names[str(current_focused_os_window_id())] = answer
    with open(fn, "w") as f:
        f.write(json.dumps(session_names))
