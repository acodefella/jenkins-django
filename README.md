# jenkins-django
## Overview
This project consists of a single bootstrap script that does the following,

* Install all required toolset [kind, kubectl, helm]
* Creates a kubernetes cluster
* Deploys Jenkins server
* Deploys Postgres database
* Deploys Django app

## Prerequisites
* [Git](https://git-scm.com/) >= 2.19.1
* [Ubuntu](https://www.ubuntu.com/) >= 20 LTS
* Internet access - as it relies heavy on publicly available bitnami helm charts

## Usage
### Kubernetes / Django / Jenkins
* This single command will take awhile to run as it does quite a few items,

```
./bootstrap.sh
```

## Development
### Improvments
Quite a few improvements are identified. It will be actioned. Contributions welcome.

## Authors
* Ilan
