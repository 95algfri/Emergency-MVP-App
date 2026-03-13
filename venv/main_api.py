from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
import time

app = FastAPI(title="Emergency Chatbot Sync API")

# Schema data yang akan dikirim oleh aplikasi Flutter Anda
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

    # Di sinilah Anda akan memasukkan logika untuk menyimpan data
    # ke Database Pusat (misal: PostgreSQL / MongoDB / Firebase)
    print(f"Menerima {len(request.unsynced_messages)} pesan dari perangkat {request.device_id}")
    
    for msg in request.unsynced_messages:
        print(f"[{msg.sender_type.upper()}] {msg.message}")

    # Simulasi proses penyimpanan sukses
    # Mengembalikan daftar ID pesan agar aplikasi Android tahu
    # pesan mana saja yang status is_synced-nya bisa diubah menjadi True
    synced_ids = [msg.id for msg in request.unsynced_messages]

    return {
        "status": "success",
        "message": "Data darurat berhasil diamankan ke server pusat.",
        "synced_message_ids": synced_ids,
        "server_timestamp": int(time.time())
    }

if __name__ == "__main__":
    import uvicorn
    # Menjalankan server di port 8000
    uvicorn.run(app, host="0.0.0.0", port=8000)