// Konfigurasi Model
final model = GenerativeModel(
  model: 'gemini-1.5-flash', // Gunakan model "Flash" karena lebih cepat & murah untuk MVP
  apiKey: apiKey,
  generationConfig: GenerationConfig(
    temperature: 0.2, // Rendah = Akurat & Konsisten
    maxOutputTokens: 200, // Hemat bandwidth
  ),
  systemInstruction: Content.text('''
    [PASTE SYSTEM INSTRUCTION DI SINI]
  '''),
);

// Fungsi Chat
Future<String> getEmergencyAdvice(String userMessage) async {
  final content = [Content.text(userMessage)];
  final response = await model.generateContent(content);
  return response.text ?? "Gagal memuat. Segera cari tempat aman.";
}