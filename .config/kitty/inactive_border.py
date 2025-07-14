from kitty.borders import Border, BorderColor, draw_edges
from kitty.boss import Boss
from kitty.fast_data_types import current_focused_os_window_id, mark_os_window_dirty
from kitty.window import DynamicColor, Window

active_border = BorderColor.active
inactive_border = BorderColor.inactive

current_os_window_id = None


def on_focus_change(boss: Boss, window: Window, data: dict[str, any]) -> None:
    global current_os_window_id
    if current_os_window_id != current_focused_os_window_id():
        current_os_window_id = current_focused_os_window_id()

        tab = window.tabref()
        os_window_id = tab.os_window_id
        tab_id = tab.id
        all_windows = tab.windows
        active_group = all_windows.active_group
        wg = active_group
        # wg = tab.windows
        # print("currennt focused os window id:", current_focused_os_window_id())
        # print("current os window id:", tab.os_window_id)

        if data["focused"]:
            color = BorderColor.active
            draw_edges(
                os_window_id, tab_id, (color, color, color, color), wg, borders=True
            )
        else:
            color = BorderColor.inactive
            draw_edges(
                os_window_id, tab_id, (color, color, color, color), wg, borders=True
            )

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
