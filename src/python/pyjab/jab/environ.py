"""Try to replicate my bash environment"""


from pysyte.paths import environ_path


def _environ_dir(name):
    """Find the path in environment and convert to a Path

    or None if nnot found

    >>> _environ_dir('HOME').isdir()
    True
    """
    try:
        result = environ_path(name)
    except KeyError:
        return None
    if not (result.isdir() or result.isfile()):
        return None
    return result


def _load_environment_paths():
    """Look for expected paths in environment

    Put them in module globals
    """
    jab_paths = [
        'HOME', 'PYTHON']
    for _ in jab_paths:
        globals()[_] = _environ_dir(_)

try:
    _ = HOME  # pylint: disable=undefined-variable
except NameError:
    _load_environment_paths()
