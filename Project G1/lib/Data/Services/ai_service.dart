import 'package:fllama/fllama.dart';

class AIService {
  bool _isModelLoaded = false;

  // System Prompt "Safety-First" dari percakapan kita sebelumnya
  final String _systemPrompt = """
  [SYSTEM INSTRUCTION: RagaBhumi - Crisis Mode]
  Tone: Urgent & Calm. Concise (max 75 words).
  Guardrails: NO Speculation. NO Medical Diagnosis. Only basic First Aid (P3K).
  Response Structure: 
  1. Immediate Action. 
  2. 3-5 Bullet Steps. 
  3. Suggest Emergency Contacts.
  """;

  Future<void> loadModel() async {
    if (_isModelLoaded) return;
    
    // Inisialisasi model dari assets
    await Fllama.loadModel("assets/models/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf");
    _isModelLoaded = true;
  }

  Future<String> getResponse(String userPrompt) async {
    if (!_isModelLoaded) await loadModel();

    // Menggabungkan System Prompt dengan input User
    final fullPrompt = "$_systemPrompt\nUSER: $userPrompt\nASSISTANT:";

    final result = await Fllama.generateText(
      prompt: fullPrompt,
      contextSize: 512, // Kecil agar hemat RAM
      temp: 0.2,        // Suhu rendah agar AI tidak "kreatif" berlebih (akurat)
      nPredict: 150,    // Membatasi panjang jawaban
    );

    return result.trim();
  }
}sS