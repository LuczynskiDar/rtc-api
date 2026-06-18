# rtc-api

**rtc-api** is a boilerplate API for HLS video streaming, built on FastAPI + SRS + FFmpeg.

Implemented core: the server accepts a stream start request, launches FFmpeg which pushes a video file in a loop via RTMP to SRS, and the client plays the resulting HLS stream in the browser. Stream access is controlled by a user→stream assignment in the database. The DB layer is based on async SQLAlchemy with raw SQL (no ORM).

The project includes a ready-made infrastructure (Docker Compose dev/prod, Makefile, multi-stage Dockerfile), but is missing: Alembic migrations, user authentication (JWT, registration/login) and tests — even though the dependencies and directory structures for them already exist.

## Project structure

```
rtc-api/
├── .devcontainer/
│   └── devcontainer.json    # VS Code Dev Container (Python, Debugpy, Ruff)
├── app/
│   ├── api/v1/routers/
│   │   ├── streams.py       # start/stop stream (FFmpeg subprocess)
│   │   ├── user_streams.py  # list of user streams
│   │   └── users.py         # (empty — auth/registration)
│   ├── db/
│   │   ├── session.py       # async engine + get_db
│   │   ├── init_db.py       # connection health check
│   │   └── base.py          # execute_one / execute_query
│   ├── schemas/user.py      # (empty)
│   ├── crud/user.py         # (empty)
│   ├── config.py            # Pydantic Settings (.env)
│   └── main.py              # FastAPI app, CORS, lifespan
├── client/
│   └── client.html          # browser HLS client (vanilla JS + hls.js)
├── content/                 # video files (mp4) mounted into the container
├── tests/
│   ├── unit/                # (empty)
│   ├── integration/         # (empty)
│   └── e2e/                 # (empty)
├── srs.conf                 # SRS media server configuration
├── Dockerfile               # multi-stage: base / dev / prod
├── docker-compose.yml       # base: postgres + srs + app
├── docker-compose.dev.yml   # overrides: hot-reload, pgAdmin, ports
├── docker-compose.prod.yml  # overrides: 4 workers, restart: always
└── Makefile                 # shortcuts for all operations
```

## Tech stack

| Layer | Tool |
|-------|------|
| Framework | FastAPI |
| ASGI server | Uvicorn |
| Database | PostgreSQL 16 (async via asyncpg) |
| ORM / DB | SQLAlchemy 2.0 async, raw SQL, Alembic (migrations — not initialized) |
| Configuration | Pydantic Settings + `.env` |
| Media server | SRS 5 (RTMP → HLS) |
| Transcoding | FFmpeg (subprocess) |
| Video client | hls.js |
| Auth (planned) | python-jose (JWT) + passlib/bcrypt |
| Testing | pytest + pytest-asyncio + httpx + pytest-playwright |
| Linting | Ruff |
| Dependency management | uv |
| Containerization | Docker Compose (dev/prod) |
| Dev environment | Dev Container (VS Code) — Python, Debugpy, Ruff |

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
    uv export --no-dev --no-hashes  -o requirements.txt
    ```

2. Development

    ```bash
    uv export --no-hashes  -o requirements-dev.txt
    ```
