import os
import sys
import path

import argv
from glob_path import glob_path, any_fnmatch

argv.add([
	('ignore','Do not ignore files (that subversion ignores)', True),
])

def common_start(a,b):
	for i, j in enumerate(zip(a,b)):
		c, d = j
		if c != d:
			return i
	return min(len(a),len(b))

def common_start_dirs(a,b):
	last_slash = 0
	for i, j in enumerate(zip(a,b)):
		c, d = j
		if c == '/':
			last_slash = i
		if c != d:
			if last_slash:
				return last_slash + 1
			return 0
	return None

def get_subversion_ignores():
	home = path.path(os.path.expanduser('~'))
	svn_config = home / '.subversion/config'
	if not svn_config.isfile():
		raise ValueError('%s is not a file' % svn_config)
		return []
	try: return  [ l for l in svn_config.lines() if l.startswith('global-ignores') ][0].split()
	except IndexError: return []

def default_ignores():
	ignores = set(get_subversion_ignores())
	ignores.update( [ '*~', '.*.sw[lmnop]' ] )
	return list( ignores )

def all_ignores(ignores=None,extra_ignores=None):
	if not ignores:
		ignores = default_ignores()
	if extra_ignores:
		ignores.extend(extra_ignores)
	return ignores
	
def remove_ignored(files,ignores=None,extra_ignores=None):
	result = []
	if not argv.options.ignore:
		return files
	globs = all_ignores(ignores,extra_ignores)
	return [ f for f in files if not any_fnmatch(f,globs) ]

def add_dir(dirs,d):
	if d in dirs: return
	if d == '': d = path.path('.')
	if d not in dirs:
		dirs.append(d)

def get_dirs(args=None):
	if not args:
		dirs = [ path.path('.') ]
	else:
		arg_paths = [ path.path(a) for a in as_paths(args) ]
		dirs = []
		for p in arg_paths:
			if p.isdir():
				add_dir(dirs,p)
			elif p.isfile():
				add_dir(dirs, p.parent)
			else:
				gp = glob_path(p)
				if gp.exists():
					add_dir(dirs,gp)
		if not dirs:
			if hasattr(args,'startswith') or len(args) == 1:
				raise ValueError('No such directory: %s' % args[0])
			else:
				raise ValueError('No such directories: %s' % ', '.join(args))
	return dirs

def as_paths(thing=None):
	'''Convert thing to a list of path.path() instances.

	Will always return a list, which might be empty
	'''
	if thing is None: return []
	try:
		thing.relpathto('.')
		return [ thing ]
	except AttributeError:
		try:
			try:
				thing.parent
				p = thing
			except AttributeError:
				thing.startswith('')
				p = path.path(thing)
			for c in '~$':
				if c in str(thing):
					p = p.expand()
					break
			return [ p ]
		except AttributeError:
			things = thing
			result = []
			try:
				for thing in things:
					result.extend(as_paths(thing))
			except TypeError:
				raise NotImplementedError('Cannot convert %r to a path' % thing)
			except ValueError:
				raise NotImplementedError('Cannot convert %r to a path' % thing)
			return result
	raise NotImplementedError('Forgot a case: %s' % thing)
				
def get_files(dirs=None):
	if not dirs:
		dirs = get_dirs()
	else:
		dirs = as_paths(dirs)
	files = []
	here = path.path('.')
	for d in dirs:
		files.extend([ here.relpathto(f) for f in d.files()])
	return files

def get_names(files=None):
	if not files: files = get_files()
	names = {}
	for f in files:
		name = f.namebase
		got = names.get(name,[])
		got.append(f)
		try: names[name] = sorted( got )
		except Exception, e: raise ', '.join([ str(got), str(names), name, f ])
	return names
