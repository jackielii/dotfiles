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
    procs = [p['cmdline'][0] if p['cmdline'] else '' for p in fp]

    # Programs that need alternate screen check (they spawn as subprocesses in tools like Claude)
    alt_screen_required = ['vim', 'nvim']
    # Programs that don't use alternate screen but should still capture keys
    always_pass = ['fzf', 'kitty-choose-tree']

    for proc in procs:
        # Always pass keys to these regardless of screen mode
        if any(p in proc.lower() for p in always_pass):
            return True
        # Only pass to vim/nvim if actually in alternate screen
        if any(p in proc.lower() for p in alt_screen_required):
            if window.screen.is_using_alternate_linebuf():
                return True

    return False

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

