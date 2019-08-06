# Welcome to DSG Automation Project

## CookieCutter

CoockieCutter is a tool that can help you generate a new project.  
In this tutorial we will learn the following:

- How to install cookie cutter
- How to generate a new project from a predefind template on Github

### **Installation**

In order to install CookieCutter run the following commands on your terminal:

```bash
python3 -m pip install --user --upgrade pip
pip install --user --upgrade cookiecutter
```

> **Warning**: if you run into problems after updating pip close and reopen the terminal  
and try to run the second command again.

### **Generating the Project**

In order to generate a new project with cookiecutter by using a template on Github  
use the following command:

```bash
cookiecutter -o <destination folder> https://github.com/datascienceisrael/automation.git
```

When the project generation will be over cookiecutter will run a script that does the following:

1. Install pipenv - A tool for managing python packsges
2. Create a new virtual environment for the project
3. Install python packages necessary for development:  
   - `pytest` - a packge that help develop tests
   - `pytest-datadir` - a package that helps manage data for tests
   - `rope` - a python formatter from vscode
   - `autopep8` - a python formatter
   - `flake8` - linter (a program that run static code analysis)
   - `jupyter` - a package that create an interactive environment for data scientists

4. Ask you to choose which data science packages do you want to install from a predefined list.

>For your convenience messages of the script progress will be printed into the terminal
