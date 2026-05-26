*This project has been created as part of the 42 curriculum by tarini.*

# Inception

## Description

This project is part of the 42 curriculum and aims to build a small containerized infrastructure using Docker and Docker Compose.

The goal is to deploy a complete web stack composed of multiple services running in isolated containers, including:

- NGINX (reverse proxy with TLS)
- WordPress (web application)
- MariaDB (database)
- Redis (cache system for WordPress)
- Several bonus services:
  - Adminer (database UI)
  - FTP server
  - Portainer (Docker management UI)
  - Static website
  - Status monitoring service

All services are orchestrated using Docker Compose and communicate through a dedicated Docker network.

---

## Project Architecture

- Each service runs in its own Docker container
- A single Docker network (`inception_network`) is used for internal communication
- Persistent data is stored using Docker volumes:
  - `mariadb_data`
  - `wordpress_data`
  - `portainer_data`

---

## Instructions

### Build and start the project

```bash
make
```

### Build only

```bash
make build
```

### Start containers

```bash
make up
```

### Stop containers

```bash
make down
```

### Full cleanup

```bash
make clean
```

### Hard cleanup (system prune + data removal)

```bash
make fclean
```

---

## Access

> Add `127.0.0.1 tarini.42.fr` to your `/etc/hosts` to use the domain URLs.

### Via domain (recommended)
| Service    | URL                              |
|------------|----------------------------------|
| WordPress  | https://tarini.42.fr             |
| Adminer    | https://tarini.42.fr/adminer     |
| Static     | https://tarini.42.fr/static      |
| Portainer  | http://localhost:9000            |
| Status     | http://localhost:8080            |

### Via localhost (VS Code port forwarding)
| Service    | URL                              |
|------------|----------------------------------|
| WordPress  | https://localhost:443            |
| Adminer    | https://localhost:443/adminer    |
| Static     | https://localhost:443/static     |
| Portainer  | http://localhost:9000            |
| Status     | http://localhost:8080            |

> **Note:** The SSL certificate is self-signed. Accept the browser security warning to proceed.

---

## Resources

* [Docker Documentation](https://docs.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)
* [NGINX](https://nginx.org/en/docs/)
* [WordPress](https://developer.wordpress.org/)
* [MariaDB](https://mariadb.org/documentation/)
* [Redis](https://redis.io/docs/)

### AI Usage

AI tools were used to:

* clarify Docker networking and volume concepts
* assist in writing clean and consistent README and docs

---

## Technical Choices

### Virtual Machine vs Docker

Virtual Machines emulate a full operating system, making them heavy and slow.
Docker shares the host kernel, making containers lightweight and faster to start.

### Secrets vs Environment Variables

Environment variables are simple but exposed in process lists.
Docker secrets are more secure and designed for sensitive data such as passwords.

### Docker Network vs Host Network

A Docker bridge network isolates containers and allows controlled communication.
Host network removes isolation and directly exposes container services.

### Volumes vs Bind Mounts

Docker volumes are managed by Docker and are portable and safe for production.
Bind mounts directly link host directories, mainly useful for development.

---

## Design Overview

NGINX acts as a reverse proxy and entry point.
It forwards HTTPS traffic to the WordPress container.
WordPress communicates with MariaDB for data storage.
Redis improves caching performance.