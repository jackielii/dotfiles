import re

from kittens.tui.handler import result_handler
from kitty.key_encoding import KeyEvent, parse_shortcut

def main():
    pass

@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return

    target = args[1] if args[1] != "_default_" else "n?vim|fzf|kitty-choose-tree"
    key_combination = args[2]

    if match_window(window, target):
        for key in key_combination.split(">"):
            encoded = encode_key_mapping(window, key)
            window.write_to_child(encoded)
        return

    typ = args[3]

    if typ == "nav":
        direction = args[4]
        boss.active_tab.neighboring_window(direction)
    elif typ == "copy_to_clipboard":
        window.copy_to_clipboard()
    elif typ == "paste_from_clipboard":
        window.paste_selection_or_clipboard()
    else:
        raise ValueError(f"Unknown type: {typ}")

def match_window(window, process_name):
    fp = window.child.foreground_processes
    return any(re.search(process_name, p['cmdline'][0] if len(p['cmdline']) else '', re.I) for p in fp)

def encode_key_mapping(window, key_mapping):
    mods, key = parse_shortcut(key_mapping)
    event = KeyEvent(
        mods=mods,
        key=key,
        shift=bool(mods & 1),
        alt=bool(mods & 2),
        ctrl=bool(mods & 4),
        super=bool(mods & 8),
        hyper=bool(mods & 16),
        meta=bool(mods & 32),
    ).as_window_system_event()

    return window.encoded_key(event)

