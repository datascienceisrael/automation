import subprocess
from typing import List, Dict


def run_command(command: List[str]) -> str or None:
    """Run a (Linux) shell command.

    Args:
        command (List[str]): The command to run.
        example: ['ls', '-l', '/path/to/folder']

    Returns:
        str or None: An error message if exists else None.
    """
    sub_proc = subprocess.Popen(command,
                                stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT)
    stdout, stderr = sub_proc.communicate()

    return stderr


def build_input_message(optional_pkgs: Dict[int, str]) -> str:
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


def get_user_input(optional_pkgs: Dict[int, str],
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
    msg = build_input_message(optional_pkgs)
    input_result = input(msg)
    input_result = [number for number in input_result.split()
                    if number.isdigit()]
    pkg_numbers = list(map(int, input_result))
    pkgs = []

    if all_pkgs_key in pkg_numbers:
        pkgs.extend(optional_pkgs.values())
    else:
        for pkg_number in pkg_numbers:
            pkg = optional_pkgs[pkg_number]
            pkgs.append(pkg)

    return pkgs


install_pipenv_cmd = ['pip', 'install', '-U', '--user', 'pipenv']
create_venv_cmd = ['pipenv', '--three']
install_dev_pkgs_cmd = ['pipenv', 'install', '--dev',
                        'pytest', 'pytest-datadir', 'flake8', 'rope',
                        'autopep8']
optional_pkgs = {1: 'numpy', 2: 'pandas', 3: 'matplotlib',
                 4: 'pyyaml', 5: 'spacy', 6: 'nltk', 7: 'seaborn', 8: 'all'}
pkgs = get_user_input(optional_pkgs, 8)
install_pkgs_cmd = ['pipenv', 'install'] + pkgs

cmd_msgs = ['Installing pipenv', 'Initializing a new virtual environment'
            f'installing dev packages: flake8, autopep8, rope, pytest and '
            f'pytest-datadir',
            f'Installing the packages you asked for: {pkgs}']
commands = [install_pipenv_cmd, create_venv_cmd, install_dev_pkgs_cmd,
            install_pkgs_cmd]

for i, cmd in enumerate(commands):
    print(cmd_msgs[i])
    stderr = run_command(cmd)
    if stderr:
        print(stderr)
        break

print('installation has finished successfully')
