import os
from kittens.tui.handler import result_handler

@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    """Save a session containing only tabs from the current OS window."""

    # Get the active tab to find which OS window we're in
    active_tab = boss.active_tab
    if not active_tab:
        return

    # Get the TabManager for the current OS window
    tab_manager = active_tab.tab_manager_ref()
    if not tab_manager:
        return

    # Collect all windows from all tabs in the current OS window
    matched_windows = set()
    for tab in tab_manager.tabs:
        for window in tab:
            matched_windows.add(window)

    # Parse options and get session path
    from kitty.session import parse_save_as_options_spec_args

    # args[0] is the kitten name, rest are the actual arguments
    opts, remaining_args = parse_save_as_options_spec_args(list(args[1:]))

    session_path = remaining_args[0] if remaining_args else None

    # Handle the '.' shortcut for current session
    if session_path == '.':
        from kitty.session import seen_session_paths
        sn = boss.active_session
        session_path = seen_session_paths.get(sn) or ''

    if not session_path:
        # Prompt for filename with default directory
        from functools import partial
        boss.get_save_filepath(
            'Enter the path at which to save the session',
            partial(save_session_callback, boss=boss, matched_windows=frozenset(matched_windows), opts=opts),
            initial_value=os.path.expanduser('~/.local/share/kitty/sessions/')
        )
    else:
        # Expand path and save directly
        session_path = os.path.expandvars(os.path.expanduser(session_path))
        save_session_for_os_window(boss, session_path, frozenset(matched_windows), opts)


def save_session_callback(session_path, boss, matched_windows, opts):
    """Callback for when user provides session path via dialog."""
    if session_path:
        save_session_for_os_window(boss, session_path, matched_windows, opts)


def save_session_for_os_window(boss, session_path, matched_windows, opts):
    """Actually save the session with the matched windows."""
    from kitty.config import atomic_save

    # Use the provided options
    ser_opts = opts

    # Resolve the path like save_as_session_part2 does
    session_path = os.path.abspath(os.path.expanduser(session_path))

    # Get the TabManager for serialization
    active_tab = boss.active_tab
    if not active_tab:
        return
    tab_manager = active_tab.tab_manager_ref()
    if not tab_manager:
        return

    # Build session content manually for just this OS window
    # Iterate through tabs in visual order (left to right in tab bar)
    lines = ['# kitty session saved from current OS window only']
    # if 'main.session' not in os.path.basename(session_path):
    lines.append('new_os_window')
    lines.append('')

    # Track which tab is currently active
    current_active_tab = tab_manager.active_tab
    active_tab_idx = 0

    for i, tab in enumerate(tab_manager):
        if tab is current_active_tab:
            active_tab_idx = i
        lines.extend(tab.serialize_state_as_session(
            session_path,
            matched_windows=matched_windows,
            ser_opts=ser_opts
        ))

    # Add focus_tab command to restore the correct active tab
    lines.append('')
    lines.append(f'focus_tab {active_tab_idx}')

    # Write the session file
    try:
        os.makedirs(os.path.dirname(session_path), exist_ok=True)
        session = '\n'.join(lines)
        atomic_save(session.encode(), session_path)
        boss.show_error('Session Saved', f'Session saved to {session_path}')
    except Exception as e:
        boss.show_error('Failed to save session', str(e))


def main(args):
    # Arguments will be passed from the mapping
    pass
