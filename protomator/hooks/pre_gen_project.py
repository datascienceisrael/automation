import sys

def check_version(major=3, minor=6):
    if sys.version_info < (major, minor):
        raise ImportError("Python {}.{} or greater is required".format(major, minor))

check_version()