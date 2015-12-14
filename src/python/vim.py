#! /usr/bin/env python2
"""Script to provide entry to the vim script"""

from __future__ import print_function
import os
import sys
import argparse
from bdb import BdbQuit


__version__ = '0.1.0'


from vim_script import vim_main


class ScriptError(NotImplementedError):
    pass


def run_args(args, methods):
    """Run any methods eponymous with args"""
    if not args:
        return False
    valuable_args = {k for k, v in args.__dict__.items() if v}
    arg_methods = {methods[a] for a in valuable_args if a in methods}
    for method in arg_methods:
        method(args)


def version(args):
    print('%s %s' % (args, __version__))
    raise SystemExit


def Use_debugger(_args):
    try:
        import pudb as pdb
    except ImportError:
        import pdb
    pdb.set_trace()


def parse_args(methods):
    """Parse out command line arguments"""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('files', metavar='files', type=str, nargs='+',
                        help='files to edit')
    parser.add_argument('-p', '--tabs', action='store_true',
                        help='put files in tabs')
    parser.add_argument('-v', '--version', action='store_true',
                        help='Show version')
    parser.add_argument('-U', '--Use_debugger', action='store_true',
                        help='Run the script with pdb (or pudb if available)')
    args = parser.parse_args()
    run_args(args, methods)
    return args


def strip_puv(args):
    result = []
    for arg in args:
        if arg in ['--Use_debugger', '--version', '--tabs']:
            continue
        if arg[0] == '-':
            arg = ''.join([c for c in arg if c not in 'pvU'])
            if arg == '-':
                continue
        result.append(arg)
    return result


def main():
    """Run the script"""
    try:
        parse_args(globals())
        args = strip_puv(sys.argv[1:])
        return vim_main(args)
    except BdbQuit:
        pass
    except SystemExit as e:
        return e.code
    except Exception, e:  # pylint: disable=broad-except
        if __version__[0] < '1':
            raise
        print(e, sys.stderr)
        return not os.EX_OK
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main())