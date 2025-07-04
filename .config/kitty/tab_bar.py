"""draw kitty tab"""
# pyright: reportMissingImports=false
# pylint: disable=E0401,C0116,C0103,W0603,R0913

from kitty.fast_data_types import (
    Screen,
    get_boss,
    get_os_window_title,
    get_options,
)
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
    draw_tab_with_separator,
)
from kitty.utils import color_as_int

opts = get_options()


def draw_session_name(draw_data: DrawData, screen: Screen, tab_bar_data: TabBarData, index: int) -> int:
    tab = get_boss().tab_for_id(tab_bar_data.tab_id)
    session_name: str = ' '+get_os_window_title(tab.os_window_id)+' '

    fg, bg, bold, italic = (
        screen.cursor.fg,
        screen.cursor.bg,
        screen.cursor.bold,
        screen.cursor.italic,
    )

    screen.cursor.bold, screen.cursor.italic = (True, True)
    colorfg = as_rgb(color_as_int(opts.color4))
    colorbg = as_rgb(color_as_int(opts.color0))
    # screen.cursor.fg, screen.cursor.bg = colorfg, bg
    # screen.draw(" ")
    screen.cursor.fg, screen.cursor.bg = (
        colorbg,
        colorfg,
    )  # inverted colors for high contrast
    screen.draw(f"{session_name}")
    # screen.cursor.fg, screen.cursor.bg = colorfg, bg
    # screen.draw(" ")
    screen.cursor.x = len(session_name) + 1
    # for i in range(1, 25):
    #     color = as_rgb(color_as_int(opts[f"color{i}"]))
    #     screen.cursor.fg, screen.cursor.bg = bg, color
    #     screen.draw(f" color{i} ")
    #     screen.cursor.x += 2

    # set cursor position
    # restore color style
    screen.cursor.fg, screen.cursor.bg, screen.cursor.bold, screen.cursor.italic = (
        fg,
        bg,
        bold,
        italic,
    )
    return screen.cursor.x


def draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    end = draw_tab_with_separator(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
    return end


def draw_right_status(screen: Screen, layout_name: str):
    fg, bg, bold, italic = (
        screen.cursor.fg,
        screen.cursor.bg,
        screen.cursor.bold,
        screen.cursor.italic,
    )

    draw_spaces = screen.columns - screen.cursor.x - len(layout_name) - 1
    if draw_spaces > 0:
        screen.draw(" " * draw_spaces)
    screen.cursor.fg, screen.cursor.bg = (
        as_rgb(color_as_int(opts.color0)),
        as_rgb(color_as_int(opts.color14)),
    )  # inverted colors for high contrast
    screen.draw(layout_name)

    screen.cursor.fg, screen.cursor.bg, screen.cursor.bold, screen.cursor.italic = (
        fg,
        bg,
        bold,
        italic,
    )


active_layout_name = ""


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    if index == 1:
        draw_session_name(draw_data, screen, tab, index)

    global active_layout_name
    if tab.is_active:
        boss = get_boss()
        w = boss.active_window
        if w.overlay_parent is not None:
            lvl = 0
            while w.overlay_parent is not None:
                w = w.overlay_parent
                lvl += 1
            overlay_label = f" [Overlay {lvl}] "
            active_layout_name = overlay_label
            # print(w.overlay_parent)
        else:
            active_layout_name = f" [{tab.layout_name.upper()}] "

    # Set cursor to where `left_status` ends, instead `right_status`,
    # to enable `open new tab` feature
    end = draw_left_status(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )

    if is_last and active_layout_name != "":
        draw_right_status(screen, active_layout_name)

    return end
