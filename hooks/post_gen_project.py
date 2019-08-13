"""A module that contains a script that automate the creation of a new project.
"""

import subprocess
from typing import Dict, List


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


def build_pkg_installation_msg(optional_pkgs: Dict[int, str]) -> str:
    """Build a message that shows the user what recommended packages he or she
    is able to install in order to begin its project.

    Args:
        optional_pkgs (Dict[int, str]): The dictionary that contains the names
        of the packages.

    Returns:
       str: The constructed message.
    """
    msg = f'choose the numbers (space separated) of the packages you want to '\
        f'install: \n'

    for (key, value) in optional_pkgs.items():
        msg += f'{key}. {value}\n'

    return msg


def get_user_packages(optional_pkgs: Dict[int, str],
                      all_pkgs_key: int,
                      no_pkgs_key: int) -> List[str]:
    """Asks the user to choose python packages to install
    from a set of standard data science packages and create a list of what
    he chose.

    Args:
        optional_pkgs (Dict[int, str]): The dictionary that contains the
        packages names.
        all_pkgs_key (int): The key of the option 'all' in the packages
        dictionary.
        no_pkgs_key (int): The key that refers to the option 'none' in the
        packages dictionary.

    Returns:
        List[str]: The list of the user requested packages.
    """
    msg = build_pkg_installation_msg(optional_pkgs)
    input_result = input(msg)
    input_result = [number for number in input_result.split()
                    if number.isdigit()]
    pkg_numbers = list(map(int, input_result))
    pkgs = []

    if no_pkgs_key in pkg_numbers:
        return []
    if all_pkgs_key in pkg_numbers:
        del optional_pkgs[all_pkgs_key]
        pkgs.extend(optional_pkgs.values())
    else:
        for pkg_number in pkg_numbers:
            pkg = optional_pkgs[pkg_number]
            pkgs.append(pkg)

    return pkgs


def on_error(undo_commands: List[List[str]],
             undo_cmd_msgs: List[str]):
    """Undo commands that run during installation by runing their
    opposite commands.

    Args:
        undo_commands (List[List[str]]): The list of commands that cancel the
        installation commands.
        undo_cmd_msgs(List[str]): A list of messages that shows the stages
        of the undo process.
    """
    for i, cmd in enumerate(undo_commands):
        print(undo_cmd_msgs[i])
        result = run_command(cmd)
        if not result:
            print('Undo installation failed please try manually.')
            break

    print('Undo installation completed successfully.')


upgrade_pip = ['python3', '-m', 'pip', 'install', '--user', '--upgrade', 'pip']
install_pipenv = ['pip', 'install', '--user', '--upgrade', 'pipenv']
create_venv = ['pipenv', '--python', '3.6']
dev_packages = ['pytest', 'pytest-datadir', 'flake8', 'rope', 'autopep8',
                'jupyter']
install_dev_pkgs = ['pipenv', 'install', '--dev'] + dev_packages
optional_pkgs = {1: 'numpy', 2: 'pandas', 3: 'matplotlib',
                 4: 'pyyaml', 5: 'spacy', 6: 'nltk', 7: 'seaborn',
                 8: 'scipy', 9: 'scikit-learn', 10: 'tqdm',  11: 'all',
                 12: 'none'}
pkgs = get_user_packages(optional_pkgs, 11, 12)
install_pkgs_cmd = ['pipenv', 'install'] + pkgs

uninstall_pipenv = ['pip', 'uninstall', '--user', 'pipenv']
delete_venv = ['pipenv', '--rm']
delete_pipenv_files = ['rm', '-rf', 'Pipfile', 'Pipfile.lock']


cmd_msgs = ['Upgrading pip',
            'Installing pipenv',
            'Initializing a new virtual environment',
            f'Installing dev packages: {dev_packages}',
            f'Installing the packages you asked for: {pkgs}']
commands = [upgrade_pip,
            install_pipenv,
            create_venv,
            install_dev_pkgs,
            install_pkgs_cmd]
undo_cmd_msgs = ['remove virtual environment',
                 'delete pipenv files (Pipfile and Pipfile.lock)',
                 'Uninstall pipenv']
undo_commands = [delete_venv,
                 delete_pipenv_files,
                 uninstall_pipenv]

for i, cmd in enumerate(commands):
    print(cmd_msgs[i])
    result = run_command(cmd)
    if not result:
        on_error(undo_commands, undo_cmd_msgs)
        break

print('installation completed successfully')
