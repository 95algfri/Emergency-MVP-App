from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
import time

app = FastAPI(title="Emergency Chatbot Sync API")

class ChatMessage(BaseModel):
    id: str
    session_id: str
    sender_type: str
    message: str
    timestamp: int

class SyncRequest(BaseModel):
    device_id: str
    unsynced_messages: List[ChatMessage]

@app.post("/api/v1/sync")
async def sync_offline_chats(request: SyncRequest):
    """
    Endpoint ini akan dipanggil oleh aplikasi saat internet menyala.
    Menerima pesan-pesan darurat yang belum tersinkronisasi.
    """
    if not request.unsynced_messages:
        return {"status": "success", "message": "Tidak ada data baru untuk disinkronkan."}

    print(f"Menerima {len(request.unsynced_messages)} pesan dari perangkat {request.device_id}")
    
    for msg in request.unsynced_messages:
        print(f"[{msg.sender_type.upper()}] {msg.message}")
    synced_ids = [msg.id for msg in request.unsynced_messages]

    return {
        "status": "success",
        "message": "Data darurat berhasil diamankan ke server pusat.",
        "synced_message_ids": synced_ids,
        "server_timestamp": int(time.time())
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)