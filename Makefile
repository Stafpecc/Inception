PURPLE          := \033[1;35m
GREEN           := \033[1;32m
RED             := \033[1;31m
YELLOW          := \033[1;33m
CYAN            := \033[1;36m
RESET           := \033[0m

DOCKER_COMPOSE  := docker compose -f srcs/docker-compose.yml
LOGIN           := tarini
DATA_DIR        := /home/$(LOGIN)/data

.PHONY: all
all: build up

.PHONY: re
re: clean all

.PHONY: build
build: color_logo
	@echo "$(PURPLE)Building Docker images...$(RESET)"
	$(DOCKER_COMPOSE) build

.PHONY: up
up:
	@echo "$(GREEN)Starting containers...$(RESET)"
	$(DOCKER_COMPOSE) up -d

.PHONY: down
down:
	@echo "$(RED)Stopping containers...$(RESET)"
	$(DOCKER_COMPOSE) down

.PHONY: restart
restart: down up


.PHONY: clean
clean:
	@echo "$(RED)Removing containers, volumes, and images...$(RESET)"
	$(DOCKER_COMPOSE) down -v --rmi all --remove-orphans

.PHONY: fclean
fclean: clean
	@echo "$(RED)Removing all Docker system data...$(RESET)"
	docker system prune -af --volumes
	@echo "$(RED)Removing data directories...$(RESET)"
	sudo rm -rf $(DATA_DIR)


.PHONY: logs
logs:
	$(DOCKER_COMPOSE) logs -f

.PHONY: maria-log
maria-log:
	docker logs mariadb

.PHONY: wp-log
wp-log:
	docker logs wordpress

.PHONY: nginx-log
nginx-log:
	docker logs nginx


.PHONY: maria-sh
maria-sh:
	@echo "$(CYAN)Entering MariaDB container...$(RESET)"
	docker exec -it mariadb bash

.PHONY: wp-sh
wp-sh:
	@echo "$(CYAN)Entering WordPress container...$(RESET)"
	docker exec -it wordpress bash

.PHONY: nginx-sh
nginx-sh:
	@echo "$(CYAN)Entering Nginx container...$(RESET)"
	docker exec -it nginx bash


.PHONY: maria-login
maria-login:
	@echo "$(CYAN)Connecting to MariaDB as root...$(RESET)"
	docker exec -it mariadb mysql -u root -p

.PHONY: maria-status
maria-status:
	docker exec -it mariadb mysqladmin -u root -p status


.PHONY: ps
ps:
	@echo "$(YELLOW)Running containers:$(RESET)"
	$(DOCKER_COMPOSE) ps

.PHONY: status
status:
	@echo "$(YELLOW)=== Containers ===$(RESET)"
	docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
	@echo ""
	@echo "$(YELLOW)=== Volumes ===$(RESET)"
	docker volume ls | grep srcs
	@echo ""
	@echo "$(YELLOW)=== Networks ===$(RESET)"
	docker network ls | grep inception

.PHONY: health
health:
	@echo "$(YELLOW)MariaDB:$(RESET) $$(docker inspect --format='{{.State.Health.Status}}' mariadb)"
	@echo "$(YELLOW)WordPress:$(RESET) $$(docker inspect --format='{{.State.Status}}' wordpress)"
	@echo "$(YELLOW)Nginx:$(RESET) $$(docker inspect --format='{{.State.Status}}' nginx)"

.PHONY: color_logo
color_logo:
	@bash logo/logo.sh

.PHONY: help
help:
	@echo "$(PURPLE)╔══════════════════════════════════════════╗$(RESET)"
	@echo "$(PURPLE)║           Inception - Makefile           ║$(RESET)"
	@echo "$(PURPLE)╚══════════════════════════════════════════╝$(RESET)"
	@echo ""
	@echo "$(GREEN)Build & Run:$(RESET)"
	@echo "  make              - build + start all containers"
	@echo "  make build        - build images"
	@echo "  make up           - start containers"
	@echo "  make down         - stop containers"
	@echo "  make restart      - down + up"
	@echo "  make re           - full clean + rebuild"
	@echo ""
	@echo "$(RED)Cleanup:$(RESET)"
	@echo "  make clean        - remove containers, volumes, images"
	@echo "  make fclean       - clean + docker prune + data dirs"
	@echo ""
	@echo "$(YELLOW)Logs:$(RESET)"
	@echo "  make logs         - follow all logs"
	@echo "  make maria-log    - MariaDB logs"
	@echo "  make wp-log       - WordPress logs"
	@echo "  make nginx-log    - Nginx logs"
	@echo ""
	@echo "$(CYAN)Shell:$(RESET)"
	@echo "  make maria-sh     - shell into MariaDB"
	@echo "  make wp-sh        - shell into WordPress"
	@echo "  make nginx-sh     - shell into Nginx"
	@echo ""
	@echo "$(CYAN)Database:$(RESET)"
	@echo "  make maria-login  - MySQL root prompt"
	@echo "  make maria-status - MySQL server status"
	@echo ""
	@echo "$(YELLOW)Status:$(RESET)"
	@echo "  make ps           - compose container list"
	@echo "  make status       - containers + volumes + networks"
	@echo "  make health       - health check status per container"
	@echo ""
	@echo "$(GREEN)VM Setup:$(RESET)"
	@echo "  make init-dirs    - create /home/tarini/data/* dirs"