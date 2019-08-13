<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

# Welcome to DSG Automation Project

- [About](#about)
- [CookieCutter](#cookiecutter)
  - [Installation](#installation)
  - [Generating the Project](#generating-the-project)
  - [Next Step](#next-step)
- [VSCoDocker](#vscodocker)
  - [Description](#description)
  - [Installation](#installation-1)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## About

Designed with and for data scientists, *DSG Automation Project* supplies a set
of tools which help  
automate complex missions of the every-day data science work.  
From generating a new project, to create a dev environment with vscode and
dockers,  
*DSG Automation Project* is here to save the :earth_asia:.  
So take a look from time to time and see what's new.

## CookieCutter

CookieCutter is a tool that can help you generate a new project.  
In this tutorial we will learn the following:

- How to install cookie cutter
- How to generate a new project from a predefined template on Github

### Installation

In order to install CookieCutter run the following commands on your terminal:

```bash
python3 -m pip install --user --upgrade pip
pip install --user --upgrade cookiecutter
```

> :warning: **Warning**: if you run into problems after updating pip close and
reopen the terminal and try to run the second command again.

### Generating the Project

In order to generate a new project with cookiecutter by using a template on
Github use the following command:

```bash
cookiecutter -o <destination folder>
https://github.com/datascienceisrael/automation.git
```

When the project generation will be over cookiecutter will run a script that
does the following:

1. Install pipenv - A tool for managing python packages
2. Create a new virtual environment for the project
3. Install python packages necessary for development:  
   - `pytest` - a package that help develop tests
   - `pytest-datadir` - a package that helps manage data for tests
   - `rope` - a python formatter from vscode
   - `autopep8` - a python formatter
   - `flake8` - linter (a program that run static code analysis)
   - `jupyter` - a package that create an interactive environment for data
   scientists

4. Ask you to choose which data science packages do you want to install from a
predefined list.

>For your convenience messages of the script progress will be printed into the
terminal

### Next Step

Go to your generated project folder and run the following command:

```bash
pipenv shell
```

That should activate your virtual environment.  
Now you can run any python pipenv or jupyter command. For example, to run a new jupyter server enter the following command:

```bash
jupyter notebook
```

## VSCoDocker

Vscodocker is a project that will help you crate a new development environment with a finger snap.

### Description

Automation scripts are provided to allow users to easily setup important installations and configurations.  
On completion, the user will have the following components installed:

  1. **Visual Studio Code + Selected Extensions**: IDE, see [link](https://code.visualstudio.com/)
  2. **Docker**: container platform [link](https://www.docker.com/)
  3. **Docker-Compose**: multi-container Docker applications [link](https://docs.docker.com/compose/)
  4. **pip**: package installer for Python [link](https://pypi.org/project/pip/)
  5. **ssh-key**: for remote connection


### Installation

Clone automation repository.

```bash
$ git clone https://github.com/datascienceisrael/automation.git
$ cd automation
```

Set proper permissions to execute the provided .sh scripts:

```
$ chmod +x *.sh
```

run `initial_config.sh`:

```bash
$ ./initial_config.sh
```

This step will install and configure vscode, docker, docker compose, pip (if not installed) and generate an ssh key pair. 

**TODO: this section needs a re-write**

> on the remote host
> 
> ```bash $ "sudo setfacl -m user:ACTUAL_USER_NAME:rw
> /var/run/docker.sock" ```
> 
> and add the user's public key from the previous step to their
> ~/.ssh/authorized_keys file
> user should now be able to ssh to the remote without a password. 

Finally,  to gain docker access from vscode execute `connect_remote_docker.sh`

```bash
$ ./connect_remote_docker.sh
```
 
