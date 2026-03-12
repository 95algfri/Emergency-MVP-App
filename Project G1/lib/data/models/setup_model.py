import os
from huggingface_hub import hf_hub_download

def download_mobile_model():
    print("Memulai unduhan model AI Offline yang dioptimasi untuk mobile...")
    
    # Direktori penyimpanan model lokal
    model_dir = "./mobile_models"
    os.makedirs(model_dir, exist_ok=True)
    
    # Kita menggunakan versi TinyLlama yang sangat ringan (contoh file GGUF)
    # Anda juga bisa menggantinya dengan repo Gemma dari Google di Kaggle/HF
    repo_id = "TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF"
    filename = "tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf" 
    
    try:
        # Mengunduh langsung ke workspace VS Code Anda
        model_path = hf_hub_download(
            repo_id=repo_id, 
            filename=filename, 
            local_dir=model_dir
        )
        print(f"Model berhasil diunduh dan siap diintegrasikan!")
        print(f"Lokasi File: {model_path}")
        print("File ini yang nantinya akan dimasukkan ke folder 'assets' di Flutter.")
        
    except Exception as e:
        print(f"Terjadi kesalahan saat mengunduh: {e}")

if __name__ == "__main__":
    download_mobile_model()