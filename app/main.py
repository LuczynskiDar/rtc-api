from fastapi import FastAPI
from contextlib import asynccontextmanager

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
)

# rejestracja routerów
# app.include_router(users.router, prefix="/users", tags=["users"])


# healthcheck – przydatny dla Dockera i monitoringu
@app.get("/health")
async def health():
    return {"status": "ok"}