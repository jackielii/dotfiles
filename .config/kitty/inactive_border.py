import datetime
from kitty.boss import Boss
from kitty.fast_data_types import current_focused_os_window_id, mark_os_window_dirty
from kitty.window import Window

# Track state to detect changes
current_os_window_id = None
last_layout = None
last_num_windows = 0
LOG_FILE = "/tmp/inactive_border.log"


def log(msg: str) -> None:
    """Log to file"""
    try:
        with open(LOG_FILE, "a") as f:
            timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
            f.write(f"[{timestamp}] {msg}\n")
    except Exception:
        pass


def update_borders(boss: Boss, window: Window, event: str = "") -> None:
    """Update borders based on focus state and layout"""
    tab = window.tabref()
    if not tab:
        return

    tm = tab.tab_manager_ref()
    if not tm:
        return

    os_window_id = tab.os_window_id
    tab_id = tab.id
    all_windows = tab.windows
    ly = tab.current_layout
    num_windows = len(all_windows)
    focused = current_focused_os_window_id() == os_window_id

    # For stack layout with focused window, force borders to be drawn
    # by temporarily making the layout think it needs borders
    if ly.name == 'stack':
        if focused:
            # Force stack layout to show borders by modifying its properties
            ly.needs_window_borders = True
            ly.must_draw_borders = True
            log(f"[{event}] Forced stack layout to show borders (needs_window_borders=True)")
        else:
            # Reset when not focused
            ly.needs_window_borders = False
            ly.must_draw_borders = False
            log(f"[{event}] Reset stack layout border flags (needs_window_borders=False)")

    # Use normal border drawing
    draw_window_borders = focused
    tab.borders(all_windows, ly, tm.tab_bar_rects, draw_window_borders)
    mark_os_window_dirty(os_window_id)

    # Debug logging
    log(f"[{event}] update_borders: os_window={os_window_id}, layout={ly.name}, "
        f"focused={focused}, draw_borders={draw_window_borders}, "
        f"num_windows={num_windows}, num_groups={all_windows.num_visble_groups}, "
        f"needs_borders={ly.needs_window_borders}, must_draw={ly.must_draw_borders}")


def on_tab_bar_dirty(boss: Boss, window: Window, data: dict[str, any]) -> None:
    """
    Called when tab bar is dirty - includes layout changes and OS window focus changes.
    See tabs.py:1137-1145 for when this is triggered.
    """
    global current_os_window_id, last_layout, last_num_windows

    tab_manager = data.get('tab_manager')
    if not tab_manager:
        return

    active_tab = tab_manager.active_tab
    if not active_tab:
        return

    # Get current state
    focused_os_window_id = current_focused_os_window_id()
    current_layout = active_tab.current_layout.name
    current_num_windows = len(active_tab.windows)

    # Check if OS window focus changed, layout changed, or number of windows changed
    os_window_changed = current_os_window_id != focused_os_window_id
    layout_changed = last_layout != current_layout
    num_windows_changed = last_num_windows != current_num_windows

    log(f"on_tab_bar_dirty: os_window_changed={os_window_changed} ({current_os_window_id}->{focused_os_window_id}), "
        f"layout_changed={layout_changed} ({last_layout}->{current_layout}), "
        f"num_windows_changed={num_windows_changed} ({last_num_windows}->{current_num_windows})")

    if os_window_changed or layout_changed or num_windows_changed:
        # Update tracked state
        current_os_window_id = focused_os_window_id
        last_layout = current_layout
        last_num_windows = current_num_windows

        # Update borders
        update_borders(boss, window, "CHANGE")


def on_load(boss: Boss, data: dict[str, any]) -> None:
    """Called when the watcher is first loaded"""
    log("="*60)
    log("Inactive border watcher loaded!")
    log(f"Logging to: {LOG_FILE}")
    log("="*60)
