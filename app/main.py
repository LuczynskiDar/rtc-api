from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from app.db.init_db import check_db_connection
from .config import settings

from app.api.v1.routers import streams, user_streams

@asynccontextmanager
async def lifespan(app: FastAPI):
    if not await check_db_connection():
        raise RuntimeError("Cannot connect to database")
    yield


app = FastAPI(
    title="RTC API",
    version="0.1.0",
    lifespan=lifespan,
    docs_url="/docs" if not settings.is_prod else None,
    redoc_url="/redoc" if not settings.is_prod else None,
    openapi_url="/openapi.json" if not settings.is_prod else None,
    debug=settings.debug,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"] if settings.is_dev else [],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(user_streams.router, prefix="/v1/users", tags=["users"])
app.include_router(streams.router, prefix="/v1/streams", tags=["streams"])

@app.get("/health")
async def health():
    response = {"status": "ok"}
    if settings.is_dev:
        response["environment"] = settings.environment
        response["debug"] = settings.debug
    return response

