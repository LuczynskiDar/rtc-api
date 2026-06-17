from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession


async def execute_query(db: AsyncSession, query: str, params: dict | None = None):
    result = await db.execute(text(query), params or {})
    return result.mappings().all()


async def execute_one(db: AsyncSession, query: str, params: dict | None = None):
    result = await db.execute(text(query), params or {})
    return result.mappings().first()