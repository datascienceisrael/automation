<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Repository Structure](#repository-structure)
- [Project Name](#project-name)
- [Project Overview](#project-overview)
      - [Example](#example)
- [Milestones](#milestones)
      - [Example](#example-1)
- [Project History](#project-history)
      - [Data Diagnostics](#data-diagnostics)
      - [Preprocessing](#preprocessing)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



# Repository Structure
-----

```
├── assets                   <--- Images embedded in the top-level README 
├── configuration            <--- Docker configuration
│   ├── config_example.py
│   ├── docker
│   │   └── Dockerfile
│   └── README.md
├── docs                     <--- Documentation, details in README
│   └── README.md
├── logs                     <--- Logs
│   └── example.log
├── README.md
├── reports                  <--- Reports for Clients
├── research                 <--- Research scripts/notebooks                
│   └── eda
│       └── example.ipynb
├── scripts                  <--- Pipeline/ETL scripts
├── src                      <--- Code, details in README
│   ├── common
│   └── README.md
└── tests                    <--- testing code/data, details in README
    ├── conftest.py
    ├── data
    ├── README.md
    └── test_example.py
```

<br><br>


# Project Name
-----

  > **Great names are short and memorable**  


<br><br>


# Project Overview
-----

  > **A quick overview of the project including the goal and data description.** 
  > **Add the project’s current status and remember to constantly update.**

<br>

#### Example  

The goal of the current project is to predict marketing campaigns efficiency, based on historical marketing campaigns.  
Historical data contains ~100 historical campaigns from the last 4 months.

**Current status**: optimizing the model in-order to improve accuracy.


<br><br>


# Milestones
-----

  > **Important events and future deadlines (if any)**

<br>

#### Example

**Data Diagnostics Completed** (01-01-2017)  
Possibly corrupted data sent to client for verification.

<br>

**New Data Received** (04-01-2017)  
Corrupted data has been fixed

<br>

**Preprocessing Completed** (14-01-2017)

  + one-hot encoding of the categorical features
  + balancing the target labels using SMOTE algorithm
  + imputation using the MICE package

notes: preprocessed data is now stored under /data/cache

<br>

**Benchmark Models Completed** (17-01-2017)  
Best model achieved 67% balanced accuracy (more details in /models/models.xlsx)

<br>

**Model Optimization** (18-01-2017 – in progress)

<br><br>


# Project History
------


  > **Detailed version of Milestones, including the conclusions and rationales behind the project workflow.**

<br>
 
### Example

#### Data Diagnostics

The features spend and impressions should never have non-positive values. 
However, during the EDA 7% of the entries contained non-positive values for spend or impressions.
This was reported and resolved.
A fresh data batch was sent to us, containing the corrected values for these entries.

<br>

#### Preprocessing

There are different ways to deal with the categorical features in the data. 
As a testbed we used one-hot encoding since it is the most straight-forward approach +  the categorical features do not contain high cardinality.

The feature age contained (as expected by the client) 30% missing values.
Imputation was done with the MICE package – which has the added value of imputing by randomly sampling from the distribution of the original feature’s complete entries.
Note: we could not find any other feature that was correlated with age, as evident in eda/plots/correlations.

<br>


