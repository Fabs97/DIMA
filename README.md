[![codecov](https://codecov.io/gh/Fabs97/DIMA/branch/master/graph/badge.svg?token=YJDI9FXV60)](https://codecov.io/gh/Fabs97/DIMA)
![Flutter](https://github.com/Fabs97/DIMA/workflows/Flutter/badge.svg)

# CityLife
- [CityLife](#citylife)
- [Scope](#scope)
  - [Customer](#customer)
  - [Supervisor](#supervisor)
- [How to install](#how-to-install)
  - [Frontend](#frontend)
    - [Prerequisites](#prerequisites)
    - [Application installation with Flutter](#application-installation-with-flutter)
  - [Backend](#backend)
    - [Prerequisites](#prerequisites-1)
    - [Application installation](#application-installation)
- [Useful Documents](#useful-documents)

A Flutter application made for the *Design and Implementation of Mobile Applications* Course at Politecnico di Milano.

# Scope


## Customer
[Fulvio Re Cecconi](https://www4.ceda.polimi.it/manifesti/manifesti/controller/ricerche/RicercaPerDocentiPublic.do?EVN_PRODOTTI=evento&k_doc=137763&polij_device_category=DESKTOP&__pj0=0&__pj1=b1d5bc8d794a6feafc8b5a8c03ae05ee), associate professor at Politecnico di Milano - Dipartimento di Architettura, Ingegneria delle Costruzioni e Ambiente Costruito.
## Supervisor

[Luciano Baresi](https://baresi.faculty.polimi.it/), full professor at Politecnico di Milano - Dipartimento di Elettronica, Informazione e Bioingegneria.

----------

# How to install
## Frontend
### Prerequisites
### Application installation with Flutter

## Backend
### Prerequisites
The following softwares and tools are required in order to locally run the backend.

-  Node.js
-  PGAdmin
-  PostgreSQL
-  Knex (installed globally via `npm`)

### Application installation
Once you've cloned the repo, please go ahead and execute the following steps:
-  Create a .env file in the `./backend` folder with the following environmental variables: 
```
CITYLIFE_ENV="CITYLIFE_ENV" #can either be "development" or "production"
CITYLIFE_DB_URL="CITYLIFE_DB_URL" #should be your production db URL
CITYLIFE_DB_HOST="CITYLIFE_DB_HOST" #should be localhost
CITYLIFE_DB_NAME="CITYLIFE_DB_NAME" #should be the name of your local DB
CITYLIFE_DB_USR="CITYLIFE_DB_USR" #should be the name of the user to which you connect to your local DB
CITYLIFE_DB_PORT="CITYLIFE_DB_PORT" #should be the port of your local DB
CITYLIFE_DB_PWD="CITYLIFE_DB_PWD" #should be the password of the user you use to connect to your local DB
```
-  
# Useful Documents

----------
**Brought you with :heartpulse: by [Alice Casali](https://github.com/AliceCasali/) and [Fabrizio Siciliano](https://github.com/Fabs97/)**