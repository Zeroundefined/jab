"""This module provides subversion handling"""


import commands


from paths import makepath
from paths import PathError


def global_ignores():
	"""A list of globs that are ignored by subversion

	>>> '*.o' in global_ignores()
	True
	"""
	svn_config = makepath('~/.subversion/config')
	if not svn_config.isfile():
		raise ValueError('%s is not a file' % svn_config)
	ignores_lines = [l for l in svn_config.lines() if l.startswith('global-ignores')]
	if not ignores_lines:
		return set()
	ignores_line = ignores_lines[0]
	_key, value = ignores_line.split('=')
	return set(value.split())


def is_svn_path(path):
	"""Whether the path is to a subversion sub-directory

	>>> is_svn_path('/path/to/.svn/file')
	True
	"""
	return '/.svn' in path


def has_svn_path(paths):
	"""Whether one of those paths is to a subversion sub-directory"""
	return any([is_svn_path(p) for p in paths])


def _get_immediately_significant_status(path_to_dir):
	command = 'svn stat --depth=immediates %s' % path_to_dir
	status, output = commands.getstatusoutput(command)
	if status:
		raise ValueError(output)
	for line in output.splitlines():
		line = line.strip()
		if not line:
			continue
		char = line[0]
		if char not in 'I?':
			return True
	return False


def _subversion_sub_directory(path_to_directory):
	return path_to_directory / '.svn'


def _existing_subversion_sub_directory(path_to_directory):
	path_to_svn = _subversion_sub_directory(path_to_directory)
	path_to_svn.assert_isdir()
	return path_to_svn


def _is_working_directory(path):
	try:
		_ = _existing_subversion_sub_directory(path)
		return True
	except PathError:
		return False


def get_significant_status(path_to_directory):
	"""Get the svn status for that directory

	Stop if any immediates have a significant status
		otherwise recurse into sub-directories
	"""
	path_to_directory = makepath(path_to_directory)
	if not path_to_directory.isdir():
		return None
	if not _is_working_directory(path_to_directory):
		return None
	status = _get_immediately_significant_status(path_to_directory)
	if status:
		return status
	for path_to_dir in path_to_directory.dirs():
		if path_to_dir[0] == '.' or path_to_dir == path_to_directory:
			continue
		status = get_significant_status(path_to_dir)
		if status:
			return status
	return None


def show_stat(path):
	if not _is_working_directory(path):
		return
	command = 'svn stat %r' % path
	_, output = commands.getstatusoutput(command)
	print output
