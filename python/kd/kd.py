"""Script to find a directory to cd to

It gets a close match to a directory from command line arguments
	Then prints that to stdout
	which allows a usage in bash like
		$ cd $(python kd.py /usr local bin)
	or
		$ cd $(python kd.py /bin/ls)

First argument is a directory
	subsequent arguments are prefixes of sub-directories
	For example:
		$ python kd.py /usr/local bi
		/usr/local/bin

Or first argument is a file
	$ python kd.py /bin/ls
	/bin

Or first argument is a stem of a directory/file
	kd.py will add * on to such a stem,
	and will always find directories first,
		looking ofr files only if there are no such directories
	$ python kd.py /bin/l
	/bin

If nothing matches then give directories in $PATH which have matching executables
	$ python kd.py ls
	/bin
"""


import os
import sys
import fnmatch


def contains_glob(path_to_directory, pattern, wanted=None):
	"""Whether the given directory contains an item which matches the given (glob) pattern"""
	if not path_to_directory:
		return False
	if wanted is None:
		wanted = lambda name: True
	for name in os.listdir(path_to_directory):
		if fnmatch.fnmatch(name, pattern):
			return wanted(os.path.join(path_to_directory, name))
	return False


def contains_directory(path_to_directory, pattern):
	"""Whether the given directory contains a directory which matches the given (glob) pattern"""
	return contains_glob(path_to_directory, pattern, os.path.isdir)


def contains_file(path_to_directory, pattern):
	"""Whether the given directory contains a file which matches the given (glob) pattern"""
	return contains_glob(path_to_directory, pattern, os.path.isfile)


def list_sub_directories(path_to_directory, pattern):
	"""A list of all sub-directories of the given directory which match the given (glob) pattern"""
	return list_items(path_to_directory, pattern, os.path.isdir)


def list_files(path_to_directory, pattern):
	"""A list of all files in the given directory which match the given (glob) pattern"""
	return list_items(path_to_directory, pattern, os.path.isfile)


def list_items(path_to_directory, pattern, wanted):
	"""A list of all items in the given directory which match the given (glob) pattern and are wanted"""
	if not path_to_directory:
		return []
	paths_to_matches = [os.path.join(path_to_directory, name) for name in os.listdir(path_to_directory) if fnmatch.fnmatch(name, pattern)]
	return [path for path in paths_to_matches if wanted(path)]


def look_under_directory(path_to_directory, prefixes):
	"""Look under the given directory for matching sub-directories

	Sub-directories match if they are prefixed with given prefixes
	If no sub-directories match, but a file matches
		then use the directory
	"""
	if not prefixes:
		return [path_to_directory]
	prefix, prefixes = prefixes[0], prefixes[1:]
	if prefix.endswith('/'):
		prefix_glob = prefix.rstrip('/')
	else:
		prefix_glob = '%s*' % prefix
	result = []
	for path_to_sub_directory in list_sub_directories(path_to_directory, prefix_glob):
		paths = look_under_directory(path_to_sub_directory, prefixes)
		result.extend(paths)
	if not result and contains_file(path_to_directory, prefix_glob):
		result = [path_to_directory]
	return result


def find_under_directory(path_to_directory, prefixes):
	"""Find one directory under path_to_directory, matching prefixes

	Can give None (no matches), or the match, or an Exception
	"""
	possibles = look_under_directory(path_to_directory, prefixes)
	if not possibles:
		return None
	if len(possibles) == 1:
		return possibles[0]
	raise NotImplementedError('Too many possiblities:\n\t%s' % '\n\t'.join(possibles))


def find_under_here(prefixes):
	"""Look for some other directories under current directory

	Try any prefixed sub-directories
		then any prefixed files
	"""
	here = os.getcwd()
	return find_under_directory(here, prefixes)


def find_in_environment_path(filename):
	"""Return the first directory in $PATH which contains a file called filename

	This is equivalent to "which" command for executable files
	"""
	if not filename:
		return None
	for path_to_directory in os.environ['PATH'].split(':'):
		if not path_to_directory:
			continue
		path_to_file = os.path.join(path_to_directory, filename)
		if os.path.isfile(path_to_file):
			return path_to_directory
	return None


def find_path_to_item(item):
	"""Find the path to the given item

	Either the directory itself, or directory of the file itself, or nothing
	"""
	if item.endswith('/'):
		if len(item) > 1:
			item = item.rstrip('/')
		return item
	if os.path.isdir(item):
		return item
	parent = os.path.dirname(item)
	if os.path.isfile(item):
		return parent
	pattern = '%s*' % os.path.basename(item)
	if contains_glob(parent, pattern):
		return parent
	return None


def previous_directory():
	"""Where we were (in bash) before this directory"""
	try:
		return os.environ['OLDPWD']
	except KeyError:
		return '~'
	return None


def find_directory(item, prefixes):
	"""Find a relevant directory relative to the item, and using prefixes (if given)

	item can be
		empty (use home directory)
		"-" (use $OLDPWD)

	Return item if it is a directory,
		or its parent if it is a file
		or one of its sub-directories (if they match prefixes)
		or a directory in $PATH
	Otherwise look for prefixes as a partial match
	"""
	path_to_item = find_path_to_item(item)
	if path_to_item:
		if not prefixes:
			return path_to_item
		path_to_prefix = find_under_directory(path_to_item, prefixes)
		if path_to_prefix:
			return path_to_prefix
	else:
		if item:
			prefixes.insert(0, item)
		if prefixes:
			path_to_item = find_under_here(prefixes)
			if not path_to_item:
				raise ValueError('could not use %r as a directory' % item)
	if path_to_item:
		return path_to_item
	return find_in_environment_path(item)


def parse_command_line():
	"""Get the arguments from the command line. Insist on at least one empty string"""
	args = sys.argv[1:]
	if not args:
		return os.path.expanduser('~'), []
	if args[0] == '-':
		args[0] = previous_directory()
	return args[0], args[1:]


def main():
	"""Show a directory from the command line arguments (or some derivative"""
	try:
		item, prefixes = parse_command_line()
		path_to_item = find_directory(item, prefixes)
		if path_to_item:
			print str(path_to_item)
		return 0
	except Exception, e:  # pylint: disable-msg=W0703
		print 'Error', e
		return 1


if __name__ == '__main__':
	sys.exit(main())
