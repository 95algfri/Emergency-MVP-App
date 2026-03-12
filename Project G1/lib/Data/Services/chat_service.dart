import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/chat_message.dart';

class ChatService {
  late Future<Isar> db;

  ChatService() {
    db = openDB();
  }

  // Membuka koneksi database
  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [ChatMessageSchema], // Schema yang di-generate build_runner
        directory: dir.path,
      );
    }
    return Isar.getInstance()!;
  }

  // Simpan Pesan Baru (User atau AI)
  Future<void> saveMessage(String text, bool isUser) async {
    final isar = await db;
    final newMessage = ChatMessage()
      ..text = text
      ..isUser = isUser
      ..timestamp = DateTime.now();

    await isar.writeTxn(() async {
      await isar.chatMessages.put(newMessage);
    });
  }

  // Ambil Semua Riwayat Pesan
  Future<List<ChatMessage>> getAllMessages() async {
    final isar = await db;
    return await isar.chatMessages.where().sortByTimestamp().findAll();
  }

  // Hapus Riwayat (Jika dibutuhkan di fitur Emergency)
  Future<void> clearHistory() async {
    final isar = await db;
    await isar.writeTxn(() => isar.chatMessages.clear());
  }
}