#!/usr/bin/env python
# License: GPLv3 Copyright: 2021, Kovid Goyal <kovid at kovidgoyal.net>
# License: GPLv3 Copyright: 2023, Yury Ershov <yuriy.ershov at gmail.com>
# https://github.com/ershov/kitty_config

import os
import re
import socket
import sys
import termios
import time
from contextlib import suppress
from functools import partial
from pprint import pformat
from typing import IO, Callable, Dict, Iterator, Optional, TypeVar, NamedTuple

from kittens.tui.operations import colored, styled

from kitty.cli import version, create_default_opts
from kitty.constants import extensions_dir, is_macos, is_wayland, kitty_base_dir, kitty_exe, shell_path
from kitty.fast_data_types import Color, num_users, get_options
from kitty.options.types import Options as KittyOpts
from kitty.options.types import defaults
from kitty.rgb import color_as_sharp
from kitty.types import MouseEvent, Shortcut, mod_to_names
from kitty.config import load_config

AnyEvent = TypeVar('AnyEvent', MouseEvent, Shortcut)
Print = Callable[..., None]
ShortcutMap = Dict[Shortcut, str]

action2key = dict()

def red(x: str) -> str:
    return colored(x, 'red')


def green(x: str) -> str:
    return colored(x, 'green')


def yellow(x: str) -> str:
    return colored(x, 'yellow')


def blue(x: str) -> str:
    return colored(x, 'blue')


def title(x: str) -> str:
    return colored(x, 'blue', intense=True)


def dim(x: str) -> str:
    return styled(x, dim=True)


def nofmt(x: str) -> str:
    return x

link_id = 1
def link(url: str, txt: str) -> str:
    global cmdArgs, link_id
    link_id += 1
    return f'\x1b]8;id={link_id};{url}\x1b\\{txt}\x1b]8;;\x1b\\' if cmdArgs.links else txt

def nolink() -> str:
    global cmdArgs
    return '\x1b]8;;\x1b\\' if cmdArgs.links else ''

def eolnl() -> str:
    global cmdArgs
    return '\n\x1b]8;;\x1b\\' if cmdArgs.links else '\n'


def linkAction(txt: str) -> str:
    import kitty.utils
    # BUG: Macos cuts out #fragment for file URLs.
    # return link(kitty.utils.docs_url(f'actions#action-{txt}'), txt)
    return link(f'https://sw.kovidgoyal.net/kitty/actions/#action-{txt}', txt)


def linkConfig(txt: str) -> str:
    import kitty.utils
    # BUG: Macos cuts out #fragment for file URLs.
    # return link(kitty.utils.docs_url(f'conf#opt-kitty.{txt}'), txt)
    return link(f'https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.{txt}', txt)


class CmdArgs:
    def __init__(self) -> None:
        self.defaults()

    def defaults(self):
        self.diff = False
        self.sort = ''
        self.plain = False
        self.links = True
        self.deleted = True
        self.empty = True
        self.parts = ['info', 'config', 'mouse', 'keys', 'colors', 'env', 'actions']
        for attr in self.parts: setattr(self, attr, None)

    @property
    def all(self):
        for attr in self.parts:
            if not getattr(self, attr): return False
        return True

    @all.setter
    def all(self, val):
        if val is None: return
        for attr in self.parts: setattr(self, attr, val)

    @property
    def debug_config(self):
        return False

    @debug_config.setter
    def debug_config(self, val):
        if val is None: return
        if val:
            self.diff = True
            self.sort = ''
            self.deleted = True
            self.empty = False
            for attr in self.parts: setattr(self, attr, True)
            self.actions = False
        else:
            self.defaults()

    def resolveParts(self):
        partVals = list(getattr(self, part) for part in self.parts)
        if any(part is True for part in partVals):
            # If there are any TRUEs, set all NONEs to FALSE
            for attr in self.parts:
                if getattr(self, attr) is None: setattr(self, attr, False)
        elif any(part is False for part in partVals):
            # If there are any FALSEs, set all NONEs to TRUE
            for attr in self.parts:
                if getattr(self, attr) is None: setattr(self, attr, True)
        else:
            # All NONEs: set all to TRUE
            for attr in self.parts: setattr(self, attr, True)
        if self.diff: self.empty = False
        if self.plain: self.links = False
        self.what = 'DIFF of' if self.diff else 'ALL'

cmdArgs = CmdArgs()

shortcutRe = r'^((([^ +]+)\+)*)(.*)$'
JustFn = Callable[[int, str], str]
def nojust(_: int, s: str): return s
def ljust(n: int, s: str): return s.ljust(n)
def rjust(n: int, s: str): return s.rjust(n)
def center(n: int, s: str): return s.center(n)
def formatConf(n: int, s: str): return linkConfig(s) + (' '*(n-len(s)))
def formatAction(n: int, s: str):
    action, args = actionSplit(s)
    return linkAction(action) + args + (' '*(n-len(s)))

class TabFmt(NamedTuple):
    indent: int = 0
    justFn: JustFn = nojust
    fmtFn: Callable[[str], str] = nofmt

def shortcutSplit(txt: str) -> tuple[str, str]:
    global shortcutRe
    m = re.fullmatch(shortcutRe, txt)
    return (m.group(1), m.group(4)) if m else ('', txt)

def actionSplit(txt: str) -> tuple[str, str]:
    global shortcutRe
    m = re.fullmatch(r'([^ ]+)( .*)', txt)
    return (m.group(1), m.group(2)) if m else (txt, '')

def shortcutFormat(mod: str, key: str) -> str:
    return yellow(mod) + green(key)

def shortcutSortKey(txt: str) -> str:
    mod, key = shortcutSplit(txt)
    return f'{key} zzz {mod}'

def star(f):
    """Parameter unpacking for lambda: https://stackoverflow.com/a/75268296/3191958"""
    return lambda args: f(*args)

def formatTable(a: list[tuple[str]], fmt: list[TabFmt]) -> list[tuple[list[tuple[str]], str]]:
    if len(a) == 0: return []
    field_lens = [max(map(len, aa)) for aa in zip(*a)]
    return [(row, ''.join(list(map(star(lambda val, fmt1, width: (' '*fmt1.indent) + fmt1.fmtFn(fmt1.justFn(width, val))),
                                   zip(row, fmt, field_lens))))) for row in a]

def printTable(a: list[list[str]], fmt: list[TabFmt], print: Print, rowFmtFn = lambda row, txt: txt) -> str:
    for row, txt in formatTable(a, fmt):
        print(rowFmtFn(row, txt))


def print_mapping_changes(what, defns: Dict[str, str], idefns: Dict[str, str], added, removed, changed, text: str, print: Print) -> None:
    global action2key, shortcutRe, cmdArgs
    printPart = getattr(cmdArgs, what)
    if printPart: print(title(text))
    table = []
    for k in sorted([(shortcutSortKey(s), s) for s in defns]):
        k = k[1]
        isremoved = k in removed
        ischanged = k in changed
        isadded = k in added
        flags = '  A  ' if isadded else '  C  ' if ischanged else '  -  ' if isremoved else '     '  # →
        if cmdArgs.diff and (not isadded and not ischanged and not isremoved): continue
        v = formatAction(0, defns[k]) if not isremoved else '     '
        orig = f'  \t({formatAction(0, defns[k])})' if ischanged or isremoved else ''
        if not isremoved: action2key.setdefault(re.sub(r' .*$', r'', defns[k]), []).append((k, defns[k]))
        if isremoved and not cmdArgs.deleted: continue
        table.append((*shortcutSplit(k), flags, v, orig))

    if printPart: printTable(table, [
                        TabFmt(fmtFn=yellow, justFn=rjust, indent=2),
                        TabFmt(fmtFn=green,  justFn=ljust),
                        TabFmt(fmtFn=red),
                        TabFmt(),
                        TabFmt(fmtFn=dim),
                    ],
                    print=print,
                    rowFmtFn=lambda row, txt: txt if row[2] != '  -  ' else dim(txt))


def compare_maps(what, final: Dict[AnyEvent, str], final_kitty_mod: int, initial: Dict[AnyEvent, str], initial_kitty_mod: int, print: Print) -> None:
    ei = {k.human_repr(initial_kitty_mod): v for k, v in initial.items()}
    ef = {k.human_repr(final_kitty_mod): v for k, v in final.items()}
    added = set(ef) - set(ei)
    removed = set(ei) - set(ef)
    changed = {k for k in set(ef) & set(ei) if ef[k] != ei[k]}
    which = link('https://sw.kovidgoyal.net/kitty/conf/#keyboard-shortcuts', 'keyboard shortcuts') if what == 'keys' else \
            link('https://sw.kovidgoyal.net/kitty/conf/#mouse-actions', 'mouse actions')
    print_mapping_changes(what, dict(list(ei.items()) + list(ef.items())), ei, added, removed, changed, f'{cmdArgs.what} {which}:', print)


def flatten_sequence_map(m) -> ShortcutMap:
    ans = {}
    for key_spec, rest_map in m.items():
        for r, action in rest_map.items():
            ans[Shortcut((key_spec,) + (r))] = action
    return ans


def compare_opts(opts: KittyOpts, print: Print) -> None:
    from .config import load_config
    print()
    print('Config options different from defaults:')
    default_opts = load_config()
    ignored = ('keymap', 'sequence_map', 'mousemap', 'map', 'mouse_map')
    changed_opts = [
        f for f in sorted(defaults._fields)
        if f not in ignored and getattr(opts, f) != getattr(defaults, f)
    ]
    field_len = max(map(len, changed_opts)) if changed_opts else 20
    fmt = f'{{:{field_len:d}s}}'
    colors = []
    for f in changed_opts:
        val = getattr(opts, f)
        if isinstance(val, dict):
            print(title(f'{f}:'))
            if f == 'symbol_map':
                for k in sorted(val):
                    print(f'\tU+{k[0]:04x} - U+{k[1]:04x} → {val[k]}')
            elif f == 'modify_font':
                for k in sorted(val):
                    print('   ', val[k])
            else:
                print(pformat(val))
        else:
            val = getattr(opts, f)
            if isinstance(val, Color):
                colors.append(fmt.format(f) + ' ' + color_as_sharp(val) + ' ' + styled('  ', bg=val))
            else:
                if f == 'kitty_mod':
                    print(fmt.format(f), '+'.join(mod_to_names(getattr(opts, f))))
                else:
                    print(fmt.format(f), str(getattr(opts, f)))

    compare_maps(opts.mousemap, opts.kitty_mod, default_opts.mousemap, default_opts.kitty_mod, print)
    def as_sc(k: SingleKey, v: KeyDefinition) -> Shortcut:
        if v.is_sequence:
            return Shortcut((v.trigger,) + v.rest)
        return Shortcut((k,))

    def as_str(defns: Iterable[KeyDefinition]) -> str:
        return ', '.join(d.human_repr() for d in defns)

    for kmn, initial_ in default_opts.keyboard_modes.items():
        initial = {as_sc(k, v[0]): as_str(v) for k, v in initial_.keymap.items()}
        final_ = opts.keyboard_modes.get(kmn, KeyboardMode(kmn))
        final = {as_sc(k, v[0]): as_str(v) for k, v in final_.keymap.items()}
        compare_maps(final, opts.kitty_mod, initial, default_opts.kitty_mod, print, mode_name=kmn)
    new_keyboard_modes = set(opts.keyboard_modes) - set(default_opts.keyboard_modes)
    for kmn in new_keyboard_modes:
        initial_ = KeyboardMode(kmn)
        initial = {as_sc(k, v[0]): as_str(v) for k, v in initial_.keymap.items()}
        final_ = opts.keyboard_modes[kmn]
        final = {as_sc(k, v[0]): as_str(v) for k, v in final_.keymap.items()}
        compare_maps(final, opts.kitty_mod, initial, default_opts.kitty_mod, print, mode_name=kmn)
    if colors:
        print(f'{title("Colors")}:', end='\n\t')
        print('\n\t'.join(sorted(colors)))


class IssueData:

    def __init__(self) -> None:
        self.uname = os.uname()
        self.s, self.n, self.r, self.v, self.m = self.uname
        try:
            self.hostname = self.o = socket.gethostname()
        except Exception:
            self.hostname = self.o = 'localhost'
        _time = time.localtime()
        self.formatted_time = self.d = time.strftime('%a %b %d %Y', _time)
        self.formatted_date = self.t = time.strftime('%H:%M:%S', _time)
        try:
            self.tty_name = format_tty_name(os.ctermid())
        except OSError:
            self.tty_name = '(none)'
        self.l = self.tty_name
        self.baud_rate = 0
        if sys.stdin.isatty():
            with suppress(OSError):
                self.baud_rate = termios.tcgetattr(sys.stdin.fileno())[5]
        self.b = str(self.baud_rate)
        try:
            self.num_users = num_users()
        except RuntimeError:
            self.num_users = -1
        self.u = str(self.num_users)
        self.U = self.u + ' user' + ('' if self.num_users == 1 else 's')

    def translate_issue_char(self, char: str) -> str:
        try:
            return str(getattr(self, char)) if len(char) == 1 else char
        except AttributeError:
            return char

    def parse_issue_file(self, issue_file: IO[str]) -> Iterator[str]:
        last_char: Optional[str] = None
        while True:
            this_char = issue_file.read(1)
            if not this_char:
                break
            if last_char == '\\':
                yield self.translate_issue_char(this_char)
            elif last_char is not None:
                yield last_char
            # `\\\a` should not match the last two slashes,
            # so make it look like it was `\?\a` where `?`
            # is some character other than `\`.
            last_char = None if last_char == '\\' else this_char
        if last_char is not None:
            yield last_char


def format_tty_name(raw: str) -> str:
    return re.sub(r'^/dev/([^/]+)/([^/]+)$', r'\1\2', raw)


def getActions():
    import inspect
    import re
    # occurences of fgrep '@ac':
    from kitty.window import Window
    from kitty.tabs import Tab
    from kitty.boss import Boss

    order = {"win": "10", "tab": "20", "sc": "30", "lay": "40",
             "mk": "50", "cp": "60", "misc": "70", "debug": "80",
             "mouse": "zzz"}

    return [v[1:] for v in sorted([
        (order.get(v.action_spec.group, v.action_spec.group),
            v.action_spec.group, k, re.sub(r'^[\r\n ]*|[\r\n\.].*$', r'', v.action_spec.doc, 0, re.S))
        for c in [Window, Tab, Boss]
        for k, v in c.__dict__.items()
        if inspect.isfunction(v) and hasattr(v, 'action_spec')
    ])]


def printActions(print: Print):
    global shortcutRe, cmdArgs
    actionsTable = formatTable(getActions(), [
        TabFmt(justFn=ljust, fmtFn=blue),
        TabFmt(justFn=formatAction, indent=2),
        TabFmt(fmtFn=dim, indent=3)])
    for (group, action, desc), rowTxt in actionsTable:
        if cmdArgs.empty: print(rowTxt)
        a = re.sub(r' .*$', r'', action)
        if a in action2key:
            if not cmdArgs.empty: print(rowTxt)
            a2ksorted = [v[1] for v in sorted([((v, shortcutSortKey(k)), (k,v)) for k, v in action2key[a]])]
            a2ksimple = [v for v in a2ksorted if v[1] == a]
            a2kcomposite = [v for v in a2ksorted if v[1] != a]
            if len(a2ksimple) > 0:
                i=0
                print('       ', end='')
                for k, _ in a2ksimple:
                    if i != 0 and (i%4) == 0: print('\n       ', end='')
                    i += 1
                    print('   ', shortcutFormat(*shortcutSplit(k)), end='')
                print()
            printTable([(*shortcutSplit(k), formatAction(0, v)) for k, v in a2kcomposite], [
                    TabFmt(indent=10, justFn=rjust, fmtFn=yellow),
                    TabFmt(           justFn=ljust, fmtFn=green),
                    TabFmt(indent=3),
                ], print=print)


def debug_config(opts: KittyOpts) -> str:
    global cmdArgs
    from io import StringIO
    out = StringIO()
    p = partial(print, file=out, end=eolnl())

    if cmdArgs.info:
        p(version(add_rev=True))
        p(' '.join(os.uname()))
        if is_macos:
            import subprocess
            p('  '.join(subprocess.check_output(['sw_vers']).decode('utf-8').splitlines()).strip())
        if os.path.exists('/etc/issue'):
            try:
                idata = IssueData()
            except Exception:
                pass
            else:
                with open('/etc/issue', encoding='utf-8', errors='replace') as f:
                    try:
                        datums = idata.parse_issue_file(f)
                    except Exception:
                        pass
                    else:
                        p(end=''.join(datums))
        if os.path.exists('/etc/lsb-release'):
            with open('/etc/lsb-release', encoding='utf-8', errors='replace') as f:
                p(f.read().strip())
        if not is_macos:
            p('Running under:', green('Wayland' if is_wayland() else 'X11'))
        p(green('Frozen:'), 'True' if getattr(sys, 'frozen', False) else 'False')
        p(green('Paths:'))
        p(yellow('  kitty:'), os.path.realpath(kitty_exe()))
        p(yellow('  base dir:'), kitty_base_dir)
        p(yellow('  extensions dir:'), extensions_dir)
        p(yellow('  system shell:'), shell_path)
        if opts.config_paths:
            p(green('Loaded config files:'))
            p(' ', '\n  '.join(opts.config_paths))
        if opts.config_overrides:
            p(green('Loaded config overrides:'))
            p(' ', '\n  '.join(opts.config_overrides))
        p()

    compare_opts(opts, p)
    p()

    if cmdArgs.env:
        p(green('Important environment variables seen by the kitty process:'))

        envVars = set('PATH LANG KITTY_CONFIG_DIRECTORY KITTY_CACHE_DIRECTORY VISUAL EDITOR SHELL'
                ' GLFW_IM_MODULE KITTY_WAYLAND_DETECT_MODIFIERS DISPLAY WAYLAND_DISPLAY USER XCURSOR_SIZE'.split())
        printTable(
            [(k, v) for k, v in sorted(os.environ.items()) if k.startswith('LC_') or k.startswith('XDG_') or k in envVars],
            [TabFmt(indent=6, justFn=ljust, fmtFn=yellow), TabFmt(indent=3)],
            print=p)
        p()

    if cmdArgs.actions:
        p(green(link('https://sw.kovidgoyal.net/kitty/actions/', f'{cmdArgs.what} available actions:')))
        printActions(p)

    return out.getvalue() if not cmdArgs.plain else re.sub(r'\x1b[^m]*m', '', out.getvalue())


def parseArgs(args):
    global cmdArgs
    import argparse
    parser = argparse.ArgumentParser(
        prog=f'kitty +kitten {args[0]}',
        usage=f'kitty +kitten {args[0]} [options]',
        description='Print kitty config.',
        epilog='''Notes:
 * Using only --{ARG}'s will include only those parts.
 * Using only --no-{ARG}'s will exclude those part from all.
 * For example, --colors will print only colors,
   while --no-colors will print everything but colors.
 * --all and --no-all will explicitly include or exclude all parts
   which then can be further refined with --{ARG}'s and --no-{ARG}'s.
''',
        formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('-d', '--diff',    action=argparse.BooleanOptionalAction, help='Print only the diff vs defaults')
    parser.add_argument('-a', '--all',     action=argparse.BooleanOptionalAction, help='Print all parts (default behavior)')
    parser.add_argument('-i', '--info',    action=argparse.BooleanOptionalAction, help='Print common info section')
    parser.add_argument('-c', '--config',  action=argparse.BooleanOptionalAction, help='Print regular config options section')
    parser.add_argument('-m', '--mouse',   action=argparse.BooleanOptionalAction, help='Print mouse bindings section')
    parser.add_argument('-k', '--keys',    action=argparse.BooleanOptionalAction, help='Print keyboard shortcuts section')
    parser.add_argument('-l', '--colors',  action=argparse.BooleanOptionalAction, help='Print colors section')
    parser.add_argument('-e', '--env',     action=argparse.BooleanOptionalAction, help='Print environment variables section')
    parser.add_argument('-t', '--actions', action=argparse.BooleanOptionalAction, help='Print actions section')
    parser.add_argument(      '--deleted', action=argparse.BooleanOptionalAction, help='Print deleted keys')
    parser.add_argument('--empty', '--unassigned', action=argparse.BooleanOptionalAction, help='Print unassigned actions')
    # parser.add_argument('-s', '--sort',    action='store', nargs=1, choices=['key', 'val', ''], help='Sort by key or action')
    parser.add_argument('--debug_config', '--debug', action=argparse.BooleanOptionalAction, help='Make output closest to "debug_config"')
    parser.add_argument(        '--links', action=argparse.BooleanOptionalAction, help='Use terminal codes for hyperlinks')
    parser.add_argument('--plain', '--plaintext', action=argparse.BooleanOptionalAction, help='Disable ansi colors')
    parser.parse_args(args[1:], cmdArgs)
    cmdArgs.resolveParts()


def main(args) -> str:
    parseArgs(args)
    print(debug_config(create_default_opts()))

from kittens.tui.handler import result_handler
@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss) -> None:
    parseArgs(args)
    boss.display_scrollback(boss.active_window, debug_config(get_options()), title='Full kitty config', report_cursor=False)


