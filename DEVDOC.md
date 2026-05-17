# Developer Documentation

## Prerequisites

- Docker
- Docker Compose
- Make
- Linux environment (recommended 42 VM or Linux host)

---

## Setup from scratch

```bash
git clone <repo>
cd inception
make init-dirs
make
```

---

## Project structure

* `srcs/` → Docker Compose and services
* `requirements/` → Dockerfiles per service
* `volumes/` → persistent data (MariaDB, WordPress)
* `Makefile` → project management

---

## Build and run

```bash
make build
make up
```

or simply:

```bash
make
```

---

## Container management

### View containers

```bash
docker ps
make status
```

### Logs

```bash
make logs
make wp-log
make maria-log
```

### Shell access

```bash
make wp-sh
make maria-sh
make nginx-sh
```

---

## Data persistence

Data is stored using Docker volumes:

* `mariadb_data` → database files
* `wordpress_data` → website files
* `portainer_data` → Portainer config

Default location (if bind mounted):

```
/home/tarini/data/
```

---

## Networks

All services communicate through:

```
inception_network (bridge)
```

This ensures isolation from the host system and controlled inter-service communication.

---

## Cleanup

### Remove containers

```bash
make clean
```

### Full system cleanup

```bash
make fclean
```

This removes:

* containers
* images
* volumes
* host data directories

---

## Debugging

Useful commands:

```bash
docker logs <container>
docker inspect <container>
docker network ls
docker volume ls
```

---

## Design overview

* NGINX acts as reverse proxy (entry point)
* WordPress handles web application
* MariaDB stores persistent data
* Redis improves caching performance
* Bonus services extend observability and usability

---

## Notes

This project is designed to demonstrate:

* container orchestration
* service isolation
* persistent storage management
* secure service communication