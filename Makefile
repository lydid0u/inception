NAME = inception

all: 
	@printf "Starting $(NAME)...\n"
	@mkdir -p /home/$(USER)/data/wordpress
	@mkdir -p /home/$(USER)/data/mariadb
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

down:
	@printf "Stopping $(NAME)...\n"
	@docker-compose -f ./srcs/docker-compose.yml down

clean: down
	@printf "Cleaning $(NAME)...\n"
	@docker system prune -a --force
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true
	@rm -rf /home/$(USER)/data

re: clean all

.PHONY: all down clean re
