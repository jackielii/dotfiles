import os
from kittens.tui.handler import result_handler
@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    tab = boss.active_tab
    if tab:
        title = tab.title
        if title:
            title = os.path.basename(title)
            boss.set_tab_title(title)

def main():
    pass
