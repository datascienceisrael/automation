"""A module that contains common functionalty of the project.
"""
import subprocess
from typing import List


def run_command(command: List[str]) -> bool:
    """Run a (Linux) shell command.
    Command template: ['command_name', 'options', 'arguments']
    Command example: ['ls', '-l', '/path/to/folder']

    Args:
        command (List[str]): The command to run.


    Returns:
        bool: boolean on success.
    """
    sub_proc = subprocess.Popen(command,
                                stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT)
    stdout, stderr = sub_proc.communicate()
    if stderr:
        print(stderr)
        return False

    return True
