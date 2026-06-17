from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from ....db.base import execute_one, execute_query
from ....db.session import get_db

router = APIRouter()

router.get("/{username}/streams")
async def user_streams(username: str, db: AsyncSession = Depends(get_db)):
    user = await execute_one(
        db, "SELECT id, username FROM users WHERE username = :username", {'username': username}
    )
    if not user:
        raise HTTPException(status_code=404, detail='User not found')
    
    streams = await execute_query(
        db, "SELECT id, title, status FROM streams WHERE user_id = :user_id", {"user_id": user['id']}
    )
    
    return {"username": user["username"], "streams": [dict(stream) for stream in streams]}