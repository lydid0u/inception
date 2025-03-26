# Variables
DOCKER_COMPOSE_FILE := ./srcs/docker-compose.yml
DATA_DIR := /home/lboudjel/data
MARIADB_DATA_DIR := $(DATA_DIR)/mariadb
WORDPRESS_DATA_DIR := $(DATA_DIR)/wordpress

# Commandes
up:
	mkdir -p $(MARIADB_DATA_DIR)
	mkdir -p $(WORDPRESS_DATA_DIR)
	docker compose -f $(DOCKER_COMPOSE_FILE) up --build -d

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down

clean:
	docker system prune
	# -docker volume rm $(DOCKER_COMPOSE_FILE)_mariadb-vol
	# -docker volume rm $(DOCKER_COMPOSE_FILE)_wordpress-vol

show:
	docker ps
	docker volume ls -q
	docker container ls -q

del:
	docker system prune -af
	docker stop `docker ps -q`
	docker rm `docker ps -aq`
	docker rmi `docker image ls -aq`
	docker volume rm `docker volume ls -q`
	docker network rm `docker network ls -q`
	docker system prune -af

renew:
	make down
	-docker volume rm $(DATA_DIR)_mariadb-vol
	-docker volume rm $(DATA_DIR)_wordpress-vol
	sudo rm -rf $(DATA_DIR)
	make up

see:
	docker logs mywordpress
	docker logs mydb
	docker logs mynginx

restart:
	make down
	make up

.PHONY: up down clean show renew see restart
