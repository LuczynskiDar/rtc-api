# app/api/v1/routers/streams.py
import asyncio
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from ....db.session import get_db
from ....db.base import execute_one
from ....config import settings

router = APIRouter()

# Active process kept in memory 
active_streams: dict[int, asyncio.subprocess.Process] = {}


@router.post("/{stream_id}/start")
async def start_stream(stream_id: int, db: AsyncSession = Depends(get_db)):
    stream = await execute_one(
        db, "SELECT id, name, file_path FROM streams WHERE id = :id", {"id": stream_id}
    )
    if not stream:
        raise HTTPException(status_code=404, detail="Stream not found")

    if stream_id in active_streams:
        raise HTTPException(status_code=400, detail="Stream already running")

    cmd = [
        "ffmpeg",
        "-re",                                  # real speed
        "-i", stream["file_path"],               # db file
        "-c:v", "copy",
        "-c:a", "copy",
        "-f", "flv",
        f"rtmp://srs:1935/live/{stream['name']}"  # ← service name "srs", not localhost!
    ]

    process = await asyncio.create_subprocess_exec(
        *cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )

    active_streams[stream_id] = process

    return {
        "status": "started",
        "stream_name": stream["name"],
        "hls_url": f"{settings.hls_base_url}/live/{stream['name']}.m3u8",
    }


@router.post("/{stream_id}/stop")
async def stop_stream(stream_id: int):
    process = active_streams.get(stream_id)
    if not process:
        raise HTTPException(status_code=404, detail="Stream not running")

    process.terminate()
    await process.wait()
    del active_streams[stream_id]

    return {"status": "stopped", "stream_id": stream_id}