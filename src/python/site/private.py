"""Module to hold private account data"""


import os
import re


def main_personal_account():
        """My main personal account"""
        return 'imap.gmail.com', 'algotrhythm', decode('TGlzbWFsdXJlLCBGZXJyeWNhcnJpZyBSb2FkICYgNzc3\n')


def other_personal_account():
        """My other personal account"""
        return 'imap.gmail.com', 'algotother', decode('Z29vZ2xlLmNvbSZiY3g0YnpydA==\n')


def employee_account():
        """My email account at work"""
        return 'mail.altobridge.com', employee_username(), decode('QWxyQjNAMTY=\n')


def second_employee_account():
        """My other work account"""
        return 'imap.gmail.com', 'ctyi.tralee', decode('Z29vZ2xlLmNvbSZiY3g0YnpydA==\n')


def personal_name():
        """What I call me"""
        return '%s %s' % (forename().title(), surname().title())


def family_name():
        """What my parents called me"""
        return surname().title()


def surname():
        """What I call my kids"""
        return 'brogan'


def forename():
        """The name I use before my surname"""
        return 'alan'


def family_emails():
        """Email addresses for my family"""
        return [
                'oisin%s@gmail.com' % surname(),
                'Kristin.%s@staff.ittralee.ie' % family_name(),
                'fiachra.%s@gmail.com' % surname(),
        ]


def personal_domain():
        """The domain name I use"""
        return 'al-got-rhythm.net'


def personal_email(username):
        """An email address for someone who is really me"""
        return _with_domain(username, '@', personal_domain)


def employee_username():
        """What my employer's machines use as my name"""
        return '%s%s' % (forename()[0], surname())


def employee_address():
        """The address my employer sends email to for me """
        return employer_email(employee_username())


def employer_email(username):
        """An email address for someone at my company"""
        return _with_employer_domain(username, '@')


def employer_server(server):
        """A server at my company"""
        return _with_employer_domain(server, '.')


def path_to_employer_repositories():
        """Where my company keeps their repositories"""
        return 'file:///usr/local/svn'


def get_issue_data_command(issue_id):
        """command to get issue data"""
        path_to_employer_tracker = '/usr/local/trunk/trackers'
        return 'ssh -i ~/.jab/ssh/id_jab -o ConnectTimeout=1 -o NumberOfPasswordPrompts=0 %s@ie-track-1 "PYTHONPATH=%s/python/site-packages %s/issues/sh/issue %s"' % (
                employee_username(),
                path_to_employer_tracker,
                path_to_employer_tracker,
                issue_id)


def regular_reports():
        """A list of senders and subjects for regular report emails"""
        return [
                ('Mary Dwyer', re.compile('3G RCS Weekly Report.*')),
                ('Altobridge_3G_OMC@3g-omc.agw.altobridge.net', re.compile('Altobridge 3G sites traffic check.*')),
                ('support@replify.com', re.compile('Build 4.2.0-[0-9]* is available')),
        ]


def spam_recipient():
        """They send spam email to this address"""
        return employer_email('iwalter')


def _with_employer_domain(prefix, joiner):
        """Join the prefix to the domain of my main work"""
        return _with_domain(prefix, joiner, _employer_domain)


def _with_domain(prefix, joiner, domain):
        """Join the prefix to the domain of my main work"""
        return joiner.join([prefix, domain()])


def _employer_domain():
        """The domain name my company uses"""
        return '%s.com' % employer_name()


def employer_name():
        """The name of my company"""
        return 'altobridge'


def mail_site_name():
        """The name of the mail site on localhost"""
        return 'mail'


def join_mail_site(prefix):
        """Join the name of the mail site on localhost to the prefix"""
        return os.path.join(prefix, mail_site_name())


def path_in_localhost(filename):
        """Where we store files for viewing on localhost

        >>> print path_in_localhost('fred.html')
        /.../Sites/mail/fred.html
        """
        mail_site = os.environ.get('MAIL_SITE_DIRECTORY', None)
        if not mail_site:
                sites = os.path.join(os.path.expanduser('~'), 'Sites')
                mail_site = join_mail_site(sites)
        return os.path.join(mail_site, filename)


def url_in_localhost(filename):
        """Where we view filename on localhost

        >>> print url_in_localhost('fred.html')
        http://localhost/.../mail/fred.html
        """
        home_name = os.path.basename(os.path.expanduser('~'))
        sites_name = 'http://localhost/~%s' % home_name
        mail_site = join_mail_site(sites_name)
        return os.path.join(mail_site, filename)

def decode(s):
        return s.decode('base64')
