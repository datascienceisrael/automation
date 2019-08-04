"""A module that contains a script that automate the creation of a new project.
"""

from typing import Dict, List

from project_generator.common import run_command


def build_pkg_installation_msg(optional_pkgs: Dict[int, str]) -> str:
    """Build a message that shows the user what recommended packges he or she
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
                      all_pkgs_key: int) -> List[str]:
    """Asks the user to choose python packages to install
    from a set of standard data science packages and create a list of what
    he chose.

    Args:
        optional_pkgs (Dict[int, str]): The dictonary that contains the
        packages names.
        all_pkgs_key (int): The key of the option 'all' in the packges
        dictionary.

    Returns:
        List[str]: The list of the user requested packages.
    """
    msg = build_pkg_installation_msg(optional_pkgs)
    input_result = input(msg)
    input_result = [number for number in input_result.split()
                    if number.isdigit()]
    pkg_numbers = list(map(int, input_result))
    pkgs = []

    if all_pkgs_key in pkg_numbers:
        del optional_pkgs[all_pkgs_key]
        pkgs.extend(optional_pkgs.values())
    else:
        for pkg_number in pkg_numbers:
            pkg = optional_pkgs[pkg_number]
            pkgs.append(pkg)

    return pkgs


def run_jupyter_server(run_jupyter_cmd: List[str]):
    """Run jupyter server base on the user choice.

    Args:
        run_jupyter_cmd (List[str]): the command that runs jupyter server.
    """
    msg = f'If you want to run code in the interactive window of vscode,\n'\
        f'you need to start a jupyter server.\n'\
        f'would you like to do so? (y\\n) '
    usr_input = ''
    while(usr_input != 'n' or usr_input != 'y'):
        usr_input = input(msg)
        if usr_input == 'y':
            print('Start jupyter server')
            result = run_command(run_jupyter_cmd)
            if not result:
                print(f'cannot run jupyter server at the moment please try '
                      f'again manually')
                break
            print('Jupyter server is running :)')
        elif usr_input == 'n':
            break
        else:
            msg = 'Choose only y\\n '


def on_error(undo_commands: List[List[str]],
             undo_cmd_msgs: List[str]):
    """Undo commands that run during installation by runing their
    opposit commands.

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
install_pipenv = ['pip', 'install', '-U', '--user', 'pipenv']
create_venv = ['pipenv', '--python', '3.6']
install_dev_pkgs = ['pipenv', 'install', '--dev',
                    'pytest', 'pytest-datadir', 'flake8', 'rope',
                    'autopep8']
optional_pkgs = {1: 'numpy', 2: 'pandas', 3: 'matplotlib',
                 4: 'pyyaml', 5: 'spacy', 6: 'nltk', 7: 'seaborn', 8: 'all'}
pkgs = get_user_packages(optional_pkgs, 8)
install_pkgs_cmd = ['pipenv', 'install'] + pkgs
install_jupyter_cmd = ['pipenv', 'install', '--dev', 'jupyter']
run_jupyter_cmd = ['pipenv', 'run', 'jupyter', 'notebook']

uninstall_pipenv = ['pip', 'uninstall', '--user', 'pipenv']
delete_venv = ['pipenv', '--rm']
delet_pipenv_files = ['rm', '-rf', 'Pipfile', 'Pipfile.lock']


cmd_msgs = ['Upgrading pip',
            'Installing pipenv',
            'Initializing a new virtual environment',
            f'Installing dev packages: flake8, autopep8, rope, pytest and '
            f'pytest-datadir',
            f'Installing the packages you asked for: {pkgs}',
            'Installing jupyter']
commands = [upgrade_pip,
            install_pipenv,
            create_venv,
            install_dev_pkgs,
            install_pkgs_cmd]
undo_cmd_msgs = ['remove viretual environment',
                 'delete pipenv files (Pipfile and Pipfile.lock)',
                 'Uninstall pipenv']
undo_commands = [delete_venv,
                 delet_pipenv_files,
                 uninstall_pipenv]

for i, cmd in enumerate(commands):
    print(cmd_msgs[i])
    result = run_command(cmd)
    if not result:
        on_error(undo_commands, undo_cmd_msgs)
        break

print('installation completed successfully')
run_jupyter_server(run_jupyter_cmd)
