# Default
.DEFAULT_GOAL := help

## Options

# Help info
help:
	@echo "Available commands:"
	@echo "  make local           - Build and run locally"
	@echo "  make staging-build   - Build and push staging image"
	@echo "  make staging-deploy  - Deploy staging"
	@echo "  make prod-build      - Build and push production image"
	@echo "  make prod-deploy     - Deploy production"

# Local dev build
local:
	@echo "Deploying local test..."
	docker compose -f deploy/docker-compose.local.yml build --pull
	docker compose -f deploy/docker-compose.local.yml up
	
# Staging build and push
staging-build:
	@echo "Building and pushing staging..."
	docker build --pull -t docker-registry.domain.com/app:staging -f deploy/Dockerfile .
	echo "$$REG_PASS" | docker login docker-registry.domain.com -u drone --password-stdin
	docker push docker-registry.domain.com/app:staging

# Staging deploy
staging-deploy:
	@echo "Deploying staging..."
	ssh -i ~/.ssh/id_drone -o StrictHostKeyChecking=no testuser@XX.XX.XX.XX "\
		echo \"$${REG_PASS}\" | docker login docker-registry.domain.com -u drone --password-stdin && \
		docker compose -f /usr/local/bin/staging/docker-compose.yml pull && \
		docker compose -f /usr/local/bin/staging/docker-compose.yml up -d --force-recreate --remove-orphans \
	"

# Prod build and deploy
prod-build:
	@echo "Building and pushing production..."
	docker build --pull -t docker-registry.domain.com/app:prod -f deploy/Dockerfile .
	echo "$$REG_PASS" | docker login docker-registry.domain.com -u drone --password-stdin
	docker push docker-registry.domain.com/app:prod

# Prod deploy
prod-deploy:
	@echo "Deploying production..."
	ssh -i ~/.ssh/id_drone -o StrictHostKeyChecking=no testuser@XX.XX.XX.XX "\
		echo \"$${REG_PASS}\" | docker login docker-registry.domain.com -u drone --password-stdin && \
		docker compose -f /usr/local/bin/prod/docker-compose.yml pull && \
		docker compose -f /usr/local/bin/prod/docker-compose.yml up -d --force-recreate --remove-orphans \
	"
