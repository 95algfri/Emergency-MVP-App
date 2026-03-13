import requests
import time
import json

def simulate_flutter_app_sync():
    print("Mulai simulasi: WaspadaAI mendeteksi koneksi internet...")
    
    url = "http://localhost:8000/api/v1/sync"
    
    current_time = int(time.time())
    
    payload = {
        "device_id": "android_pixel_001",
        "unsynced_messages": [
            {
                "id": "msg_001",
                "session_id": "darurat_gempa_01",
                "sender_type": "user",
                "message": "Terjadi gempa bumi, apa yang harus saya lakukan pertama kali?",
                "timestamp": current_time - 300 # 5 menit yang lalu
            },
            {
                "id": "msg_002",
                "session_id": "darurat_gempa_01",
                "sender_type": "ai",
                "message": "Tetap tenang. Segera berlindung di bawah meja atau perabot yang kuat (Drop, Cover, Hold On). Jauhi jendela kaca dan benda yang bisa jatuh.",
                "timestamp": current_time - 295
            },
            {
                "id": "msg_003",
                "session_id": "darurat_gempa_01",
                "sender_type": "user",
                "message": "Saya sudah di bawah meja. Kapan saya bisa keluar?",
                "timestamp": current_time - 240
            },
             {
                "id": "msg_004",
                "session_id": "darurat_gempa_01",
                "sender_type": "ai",
                "message": "Tetap berlindung sampai guncangan benar-benar berhenti. Setelah aman, evakuasi keluar bangunan melalui tangga, jangan gunakan lift.",
                "timestamp": current_time - 235
            }
        ]
    }
    
    print(f"Mengirim {len(payload['unsynced_messages'])} pesan offline ke API Pusat...\n")
    
    try:
        response = requests.post(url, json=payload)
        
        if response.status_code == 200:
            print("✅ SINKRONISASI BERHASIL!")
            print("Respons dari Server:")
        
            response_data = response.json()
            print(json.dumps(response_data, indent=4))
            
            print("\nLangkah di Flutter selanjutnya:")
            print("Update database lokal Isar/SQLite. Ubah status pesan dengan ID berikut menjadi 'is_synced = true':")
            for msg_id in response_data.get("synced_message_ids", []):
                print(f" - {msg_id}")
        else:
            print(f"❌ Sinkronisasi Gagal. Status Code: {response.status_code}")
            print(response.text)
            
    except requests.exceptions.ConnectionError:
        print("❌ Gagal terhubung ke API. Pastikan server main_api.py sedang berjalan di terminal lain!")

if __name__ == "__main__":
    simulate_flutter_app_sync()