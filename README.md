[![codecov](https://codecov.io/gh/Fabs97/DIMA/branch/master/graph/badge.svg?token=YJDI9FXV60)](https://codecov.io/gh/Fabs97/DIMA)
![Flutter](https://github.com/Fabs97/DIMA/workflows/Flutter/badge.svg)

# CityLife
- [CityLife](#citylife)
- [Scope](#scope)
- [Features](#features)
  - [Customer](#customer)
  - [Supervisor](#supervisor)
- [How to install](#how-to-install)
  - [Frontend](#frontend)
    - [Prerequisites](#prerequisites)
    - [Application installation](#application-installation)
  - [Backend](#backend)
    - [Prerequisites](#prerequisites-1)
    - [Application installation](#application-installation-1)
- [Useful Documents](#useful-documents)

A Flutter application made for the *Design and Implementation of Mobile Applications* Course at Politecnico di Milano.

# Scope
The scope of the application requires the end users to collect reliable information regarding the surroundings' conditions. Given the high engagement rates that are required by the [Customer](#customer), the application must support a quick access flow, a reward system, and a easy-to-use input flow. In addition, a periodical data analysis executed retrospectively with large data quantities input by the users will be conducted, which requires a *strong* database with easily queryable data.

# Features
The state of art of the application includes the following features:
- [x] **One-Tap Logins**:
  - [x] *Email/Password Login*:
    - [x] Email verification
  - [x] *Social Login*:
    - [x] GitHub
    - [x] Twitter
    - [x] Facebook
    - [x] Google
  - [x] *2 Factors Authentication*
- [x] **Impressions insertion**:
  - [x] *Structural impression flow*:
    - [x] Structural impression database data
    - [x] Structural impression image storage
  - [x] *Emotional impression flow*:
    - [x] Emotional impression database data
    - [x] Emotional impression image storage
- [x] **Impressions in-app analysis**:
  - [x] *Personal impressions list view*
  - [x] *City impressions dynamic map*
  - [x] *Impression detail*
- [x] **Personal profile**:
  - [x] *Profile name editing*
  - [x] *Technical Role*
  - [x] *2 Factor Authentication activation*
- [x] **Users engagement**:
  - [x] *Profile experience*
  - [x] *Badges screen*
  - [x] *Badges acquisition*
## Customer
![Fulvio Re Cecconi](/readme_images/cecconi.jpg)

[**Fulvio Re Cecconi**](https://www4.ceda.polimi.it/manifesti/manifesti/controller/ricerche/RicercaPerDocentiPublic.do?EVN_PRODOTTI=evento&k_doc=137763&polij_device_category=DESKTOP&__pj0=0&__pj1=3b1c7a0b7e373822c5bdac98fb70ae55), associate professor at [Politecnico di Milano - Dipartimento di Architettura, Ingegneria delle Costruzioni e Ambiente Costruito](https://www.dabc.polimi.it/).
## Supervisor
![Luciano Baresi](/readme_images/baresi.jpeg)

[**Luciano Baresi**](https://baresi.faculty.polimi.it/), full professor at [Politecnico di Milano - Dipartimento di Elettronica, Informazione e Bioingegneria](https://www.deib.polimi.it/en/home).

----------

# How to install
## Frontend
### Prerequisites
The following requirements are needed in order to run the application on an emulator in debug/profile/release mode:
- [Flutter, latest version](https://flutter.dev/docs/get-started/install). Recommended branches are `dev`, `stable` and `beta`;

### Application installation
In order to run the application, it is required to define a few environmental variables with the formula `--dart-define=VAR_KEY=VAR_VALUE`. The following variables must be defined:
```
CITYLIFE_TWITTER_CONSUMER_KEY=(request one to the devs or create one of your own)
CITYLIFE_TWITTER_CONSUMER_SECRET=(request one to the devs or create one of your own)
CITYLIFE_GITHUB_CLIENT_ID=(request one to the devs or create one of your own)
CITYLIFE_GITHUB_CLIENT_SECRET=(request one to the devs or create one of your own)
CITYLIFE_AUTH_REDIRECT_URL=https://citylife-c2d0c.firebaseapp.com/__/auth/handler
```

## Backend
### Prerequisites
The following softwares and tools are required in order to locally run the backend.

-  [Node.js](https://nodejs.org/en/download/)
-  [PostgreSQL](https://www.postgresql.org/download/)
-  [Knex (installed globally via `npm`)](http://knexjs.org/#Installation)
-  [PGAdmin (optional)](https://www.pgadmin.org/download/)

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