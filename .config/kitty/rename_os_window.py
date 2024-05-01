from kitty.fast_data_types import (
    current_focused_os_window_id,
    last_focused_os_window_id,
    set_os_window_title,
)


def main(args):
    return input("Input OS window title> ")


def handle_result(args, answer, target_window_id, boss):
    os_window_id = current_focused_os_window_id() or last_focused_os_window_id()
    set_os_window_title(os_window_id, answer)
