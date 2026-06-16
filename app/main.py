from fastapi import FastAPI
from contextlib import asynccontextmanager
# from config import settings
from .config import settings

# from app.routers import users  # przykładowy router
# from app.database import init_db


# startup i shutdown aplikacji
@asynccontextmanager
async def lifespan(app: FastAPI):
    # startup – odpala się przy starcie
    # await init_db()
    yield
    # shutdown – odpala się przy zamknięciu


app = FastAPI(
    title="RTC API",
    version="0.1.0",
    lifespan=lifespan,
    docs_url="/docs" if not settings.is_prod else None,
    redoc_url="/redoc" if not settings.is_prod else None,
    openapi_url="/openapi.json" if not settings.is_prod else None,
    debug=settings.debug,
)

# app.include_router(users.router, prefix="/users", tags=["users"])


# healthcheck – przydatny dla Dockera i monitoringu
@app.get("/health")
async def health():
    response = {"status": "ok"}
    if settings.is_dev:
        response["environment"] = settings.environment
        response["debug"] = settings.debug
    return response