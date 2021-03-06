"""Script to display a todo list"""


from __future__ import print_function
import re
import os
import sys
try:
    from namedtuple import namedtuple  # pylint: disable=import-error
except ImportError:
    from collections import namedtuple


from pysyte.paths import path
from pysyte.colours import texts


def todo_file():
    """Get the filename from the environment"""
    # Tell pylint not to warn that this is a todo
    # pylint: disable-msg=W0511
    if sys.argv[1:]:
        arg = sys.argv[1]
        if os.path.isfile(arg):
            return arg
    jab = path('~/jab')
    return jab / 'todo.txt'


def read_todo(path_to_todo):
    result = []
    for line in open(path_to_todo):
        line = line.rstrip()
        if not line:
            continue
        result.append(line)
    return result


def read_todo_items():
    path_to_todo = todo_file()
    lines = read_todo(path_to_todo)
    return [parse_todo_line(l) for l in lines]


def priorities():
    """The recognised priorities in this system"""
    Priority = namedtuple('Priority', 'number, name, colour')
    # pylint: disable=bad-whitespace
    # Yeah, fuck off!
    return [
        Priority(0, 'bug',       'red'),
        Priority(1, 'yesterday', 'magenta'),
        Priority(2, 'today',     'blue'),
        Priority(3, 'tomorrow',  'cyan'),
        Priority(4, 'feature',   'green'),
        Priority(5, 'wish',      'yellow'),
        Priority(6, 'text',      'gray'),
    ]


def priority_keys_string():
    """A string with the priority numbers in this system"""
    return ''.join([str(priority.number) for priority in priorities()])


def priority_colour(priority_number):
    for priority in priorities():
        if priority_number == priority.number:
            return priority.colour
    return 'white'


def parse_todo_line(line):
    """Extract a list of todo items from a list of lines

    Each item is a tuple of (text, priority)
    """
    item_regexp = re.compile('^(?P<text>.*), (?P<priority>[%s])$' %
                             priority_keys_string())
    match = item_regexp.match(line)
    TodoItem = namedtuple('TodoItem', 'text, priority')
    if not match:
        return TodoItem(line, -1)
    text = match.groupdict()['text']
    priority = match.groupdict()['priority']
    return TodoItem(text, int(priority))


def show_todo_item(item):
    """Show the item on screen, coloured by it's priority"""
    colour = priority_colour(item.priority)
    print(texts.colour_text(item.text, colour))


def main():
    """Read all todo items and show them on screen"""
    for item in read_todo_items():
        show_todo_item(item)
    return 0


if __name__ == '__main__':
    sys.exit(main())
