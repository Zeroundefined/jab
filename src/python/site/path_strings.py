import os

from pysyte.paths import home
from pysyte.paths import path

def environ_paths():
    import environ
    result = {}
    all_items = os.environ.items() + environ.jab.items()
    for key,value in all_items:
        if key in result:
            if not value or value == result[key]:
                continue
            # print '%s:%s -> %s' % (key,result[key],value)
            # raise KeyError('%s:%s -> %s' % (key,result[key],value))
        existing_paths = [ p for p in string_to_paths(value) if p.exists() ]
        if existing_paths:
            if existing_paths[1:] or key.endswith('PATH'):
                result[key] = existing_paths
            else:
                result[key] = existing_paths[0]
    class Result(object):
        def __init__(self, x):
            self.__dict__.update(x)
    return Result(result)

def string_to_paths(string):
    for c in ':, ;':
        if c in string:
            return strings_to_paths( string.split(c) )
    return [ path(string) ]

def strings_to_paths(strings):
    return [ path(s) for s in strings ]

def split_directories(strings):
    strings = strings_to_paths(strings)
    return [ p for p in strings if p.isdir() ], [ p for p in strings if not p.isdir() ]

def split_files(strings):
    strings = strings_to_paths(strings)
    return [ p for p in strings if p.isfile() ], [ p for p in strings if not p.isfile() ]

def split_directories_files(strings):
    strings = strings_to_paths(strings)
    return [ p for p in strings if p.isdir() ], [ p for p in strings if p.isfile() ], [ p for p in strings if not (p.isfile() or p.isdir())]

def files(strings):
    return split_files(strings)[0]

def directories(strings):
    return split_directories(strings)[0]

def from_home(p):
    return home().relpathto(p)

environ = environ_paths()
