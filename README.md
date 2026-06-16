# rtc-api

Real Time Commnication Api

## Requirements

- Docker Desktop
- Make
- uv

## Quick Start

Copy and fill in the environment variables:

    cp .env.example .env

Start the project:

    make dev

## Commands

### Dev

| Command       | Description           |
|---------------|-----------------------|
| make dev      | Start with logs       |
| make dev-d    | Start in background   |
| make down     | Stop                  |
| make down-v   | Stop + remove volumes |
| make logs     | App logs              |
| make shell    | Enter container       |

### Tests

| Command               | Description                    |
|-----------------------|--------------------------------|
| make test             | Run all tests                  |
| make test-unit        | Unit tests only                |
| make test-integration | Integration tests only         |
| make test-e2e         | E2E tests only                 |
| make test-cov         | Tests with coverage (htmlcov/) |

### Linting

| Command       | Description      |
|---------------|------------------|
| make lint     | Check linting    |
| make format   | Format code      |
| make lint-fix | Auto fix linting |

### Database

| Command                         | Description            |
|---------------------------------|------------------------|
| make migrate                    | Upgrade head           |
| make migrate-down               | Downgrade by one       |
| make migrate-new name=add_users | Create new migration   |
| make migrate-history            | Show migration history |
| make db-shell                   | psql in container      |

### Production

| Command        | Description |
|----------------|-------------|
| make prod      | Start       |
| make prod-down | Stop        |
| make prod-logs | Logs        |

### Utilities

| Command      | Description                   |
|--------------|-------------------------------|
| make ps      | Container status              |
| make build   | Build images                  |
| make rebuild | Build without cache           |
| make prune   | Clean unused Docker resources |

## Dependencies

### Install

1. Production
    ```bash
    
    uv add fastapi uvicorn[standard] sqlalchemy alembic asyncpg pydantic-settings python-jose[cryptography] passlib[bcrypt]
    ````

2. Developer

```bash
uv add --dev pytest pytest-asyncio httpx pytest-playwright ruff
```

Install playwright

```bash
playwright install
playwright install chromium
```

### Synchronize

1. Local Installation (prod + dev)

    ```bash
    uv sync
    ```

2. On server

    ```bash
    uv sync --no-dev
    ```

### Export to requirements

1. Produkction

    ```bash
    uv export --no-dev -o requirements.txt
    ```

2. Development

    ```bash
    uv export -o requirements-dev.txt
    ```
