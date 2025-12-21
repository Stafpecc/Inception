PURPLE          := \033[1;35m
GREEN           := \033[1;32m
RED             := \033[1;31m
RESET           := \033[0m

DOCKER_COMPOSE=docker-compose -f srcs/requirements/docker-compose.yml

all: build up

color_logo:
	@bash logo/logo.sh
.PHONY: color_logo

build: color_logo
	@echo "$(PURPLE)Building Docker images...$(RESET)"
	$(DOCKER_COMPOSE) build
.PHONY: build

up:
	@echo "$(GREEN)Starting containers...$(RESET)"
	$(DOCKER_COMPOSE) up -d
.PHONY: up

down:
	@echo "$(RED)Stopping containers...$(RESET)"
	$(DOCKER_COMPOSE) down
.PHONY: down

clean: down
	@echo "$(RED)Cleaning containers, volumes, and images...$(RESET)"
	$(DOCKER_COMPOSE) rm -f
	docker volume prune -f
	docker system prune -f
.PHONY: clean

re: clean all
.PHONY: re