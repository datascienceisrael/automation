# Welcome to DSG Automation Project

## Cooki Cutter

CoockieCutter is a tool that can help you generate a new project.  
In this tutorial we will learn the following:

- How to install cookie cutter
- How to generate a new project from a predefind template on github

### **Installation**

In order to install Cookie Cutter run the following commands on your terminal:

```bash
python3 -m pip install --user --upgrade pip
pip install cookiecutter
```

> **Warning**: if you run into problems after updating pip close and reopen the terminal  
and try to run the second command againg

### **Generating the Project**

In order to generate a new project with cookie cutter by using a template in Github  
use the following command:

```bash
cookiecutter -o <destination folder> https://github.com/datascienceisrael/automation.git
```

When the project generation will be over cookie cutter will run a script that does the following:

1. Install pipenv - A tool for managing python packsges
2. Create a new virtual environment for the project
3. Install python packages necessary for development
4. Ask you to choose which data science packges do you want to install from a predfined list.

>For your convenience messages of the script progress will be printed into the terminal
