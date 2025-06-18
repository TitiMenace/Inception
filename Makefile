
NAME			= inception

# Chemins
SRC_DIR			= srcs
COMPOSE_FILE	= $(SRC_DIR)/docker-compose.yml
ENV_FILE		= $(SRC_DIR)/.env

# Commandes
DOCKER_COMPOSE	= docker-compose -f $(COMPOSE_FILE)

# Règles
all: $(NAME)

$(NAME):
	@echo "🚀 Lancement de $(NAME)..."
	$(DOCKER_COMPOSE) up --build -d

stop:
	@echo "🛑 Arrêt des conteneurs..."
	$(DOCKER_COMPOSE) stop

clean:
	@echo "🧹 Suppression des volumes..."
	$(DOCKER_COMPOSE) down -v

fclean: clean
	@echo "🔥 Suppression des images, réseaux et orphelins..."
	$(DOCKER_COMPOSE) down --rmi all --remove-orphans

re: fclean all

.PHONY: all stop clean fclean re
