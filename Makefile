# ============================================================
# Variables
# ============================================================
COMPOSE_BASE = docker compose -f docker-compose.yml
COMPOSE_DEV  = $(COMPOSE_BASE) -f docker-compose.dev.yml
COMPOSE_PROD = $(COMPOSE_BASE) -f docker-compose.prod.yml
APP          = app

# ============================================================
# Dev
# ============================================================
dev:
	$(COMPOSE_DEV) up --build

dev-d:
	$(COMPOSE_DEV) up --build -d

down:
	$(COMPOSE_DEV) down

down-v:
	$(COMPOSE_DEV) down -v

logs:
	$(COMPOSE_DEV) logs -f $(APP)

logs-db:
	$(COMPOSE_DEV) logs -f postgres

shell:
	$(COMPOSE_DEV) exec $(APP) bash

# ============================================================
# Tests
# ============================================================
test:
	$(COMPOSE_DEV) exec $(APP) uv run pytest tests/ -v

test-unit:
	$(COMPOSE_DEV) exec $(APP) uv run pytest tests/unit -v

test-integration:
	$(COMPOSE_DEV) exec $(APP) uv run pytest tests/integration -v

test-e2e:
	$(COMPOSE_DEV) exec $(APP) uv run pytest tests/e2e -v

test-cov:
	$(COMPOSE_DEV) exec $(APP) uv run pytest tests/ --cov=app --cov-report=html

# ============================================================
# Linting / Formatting
# ============================================================
lint:
	$(COMPOSE_DEV) exec $(APP) uv run ruff check .

format:
	$(COMPOSE_DEV) exec $(APP) uv run ruff format .

lint-fix:
	$(COMPOSE_DEV) exec $(APP) uv run ruff check . --fix

# ============================================================
# Database / Alembic
# ============================================================
migrate:
	$(COMPOSE_DEV) exec $(APP) uv run alembic upgrade head

migrate-down:
	$(COMPOSE_DEV) exec $(APP) uv run alembic downgrade -1

migrate-new:
	$(COMPOSE_DEV) exec $(APP) uv run alembic revision --autogenerate -m "$(name)"

migrate-history:
	$(COMPOSE_DEV) exec $(APP) uv run alembic history

db-shell:
	$(COMPOSE_DEV) exec postgres psql -U $${POSTGRES_USER} -d $${POSTGRES_DB}

# ============================================================
# Production
# ============================================================
prod:
	$(COMPOSE_PROD) up --build -d

prod-down:
	$(COMPOSE_PROD) down

prod-logs:
	$(COMPOSE_PROD) logs -f $(APP)

# ============================================================
# Utilities
# ============================================================
ps:
	$(COMPOSE_DEV) ps

build:
	$(COMPOSE_DEV) build

rebuild:
	$(COMPOSE_DEV) build --no-cache

prune:
	docker system prune -f

.PHONY: dev dev-d down down-v logs logs-db shell \
        test test-unit test-integration test-e2e test-cov \
        lint format lint-fix \
        migrate migrate-down migrate-new migrate-history db-shell \
        prod prod-down prod-logs \
        ps build rebuild prune