from typing import Any, Dict

from kitty.borders import Border, BorderColor, draw_edges
from kitty.boss import Boss
from kitty.fast_data_types import current_focused_os_window_id, mark_os_window_dirty
from kitty.window import DynamicColor, Window

active_border = BorderColor.active
inactive_border = BorderColor.inactive

def on_focus_change(boss: Boss, window: Window, data: Dict[str, Any])-> None:
    print(data)
    tab = window.tabref()
    all_windows = tab.windows
    active_group = all_windows.active_group
    wg = active_group
    # wg = tab.windows
    # print("currennt focused os window id:", current_focused_os_window_id())
    # print("current os window id:", tab.os_window_id)

    os_window_id = tab.os_window_id
    tab_id = tab.id
    color = inactive_border
    # draw_edges(os_window_id, tab_id, (color, color, color, color), wg, borders=True)

    if tab.os_window_id != current_focused_os_window_id():
        color = BorderColor.inactive
        tab.relayout_borders()
        draw_edges(os_window_id, tab_id, (color, color, color, color), wg, borders=True)
        mark_os_window_dirty(os_window_id)
    elif data["focused"]:
        color = BorderColor.active
        draw_edges(os_window_id, tab_id, (color, color, color, color), wg, borders=True)
        # tab.relayout_borders()
        mark_os_window_dirty(os_window_id)

    # print("active border:", BorderColor.active)
    # print("inactive border:", BorderColor.inactive)
    # if not data["focused"]:
    #     BorderColor.active = inactive_border
    #     BorderColor.inactive = active_border
    # else:
    #     BorderColor.active = active_border
    #     BorderColor.inactive = inactive_border
    # tab.relayout_borders()
    #     window.change_colors({DynamicColor.default_bg: "black"})
    #     window.
    # else:
    #     window.change_colors({DynamicColor.default_bg: "#333"})

