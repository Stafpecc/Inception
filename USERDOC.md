# User Documentation

## Overview

This project deploys a full web stack using Docker containers. It includes:

- A secure website (WordPress + NGINX)
- A database (MariaDB)
- Optional tools (Adminer, FTP, Portainer, etc.)

---

## Start the project

```bash
make
```

---

## Stop the project

```bash
make down
```

---

## Access the services

### Website

```
https://tarini.42.fr
```

### Adminer (Database UI)

```
http://localhost:8081
```

### Static website

```
http://localhost:8082
```

### Portainer (Docker UI)

```
http://localhost:9000
```

### Status page

```
http://localhost:8080
```

---

## Check running services

```bash
make ps
docker ps
```

---

## Credentials

Credentials are defined in:

* `.env` file
* Docker environment variables

Sensitive data such as database passwords are not hardcoded in the source code.

---

## Verify services

```bash
make health
```

or

```bash
docker ps
```

---

## Restart services

```bash
make restart
```