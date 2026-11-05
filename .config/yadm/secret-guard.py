#!/usr/bin/env python3
"""Check staged blobs, never working files; report metadata only, never secrets."""
import fnmatch
import json
import os
from pathlib import Path, PurePosixPath
import shutil
import subprocess
import sys
import tempfile


def git(*args):
    return subprocess.check_output(['git', *args])


def main():
    paths = git('diff', '--cached', '--name-only', '--diff-filter=ACMRT', '-z').decode(errors='surrogateescape').split('\0')
    paths = [p for p in paths if p]
    if not paths:
        return 0
    patterns = ['.secrets', '.secrets.*', '.gnupg/*', '*.pem', '*.p12', '*.pfx', '.env', '*/.env', '.env.*', '*/.env.*']
    patterns += [s.strip() for s in (Path.home()/'.config/yadm/encrypt').read_text().splitlines() if s.strip() and not s.lstrip().startswith('#')]
    blocked = [p for p in paths if any(fnmatch.fnmatchcase(p, pat) for pat in patterns)]
    if blocked:
        print('Commit blocked: private files must stay outside plaintext Git (use yadm encrypt):', file=sys.stderr)
        for p in blocked:
            print('  ' + repr(p), file=sys.stderr)
        return 1
    scanner = shutil.which('gitleaks')
    if not scanner:
        print('Commit blocked: install gitleaks with Homebrew before committing.', file=sys.stderr)
        return 1
    with tempfile.TemporaryDirectory(prefix='yadm-secret-check-') as temp:
        root = Path(temp)
        files = root/'staged'
        files.mkdir()
        for p in paths:
            # The encrypted yadm archive is intentionally versioned.
            if p == '.local/share/yadm/archive':
                continue
            if PurePosixPath(p).is_absolute() or '..' in PurePosixPath(p).parts:
                raise RuntimeError('Unsafe staged path')
            dest = files/p
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_bytes(git('show', ':' + p))
            dest.chmod(0o600)
        config = root/'rules.toml'
        config.write_text('[extend]\nuseDefault = true\n')
        report = root/'report.json'
        # Explicit config and ignore path prevent accidental project-level bypasses.
        env = {k:v for k,v in os.environ.items() if not k.startswith('GITLEAKS_')}
        result = subprocess.run([scanner, 'dir', str(files), '--config', str(config), '--gitleaks-ignore-path', str(root/'no-ignore'), '--ignore-gitleaks-allow', '--redact=100', '--no-banner', '--log-level', 'error', '--report-format', 'json', '--report-path', str(report)], env=env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        if result.returncode:
            print('Commit blocked by staged-content secret scan.', file=sys.stderr)
            if report.exists():
                for finding in json.loads(report.read_text()):
                    name = finding.get('File', '')
                    if name.startswith(str(files) + '/'):
                        name = name[len(str(files)) + 1:]
                    print('  {}: {} (line {})'.format(repr(name), finding.get('RuleID', 'unknown'), finding.get('StartLine', '?')), file=sys.stderr)
            print('Remove secrets, stage the cleaned files, and retry. No secret values are printed.', file=sys.stderr)
            return 1
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except Exception:
        print('Commit blocked: secret guard could not complete; inspect its configuration.', file=sys.stderr)
        sys.exit(1)
