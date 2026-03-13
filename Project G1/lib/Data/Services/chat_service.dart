import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/chat_message.dart';

class ChatService {
  late Future<Isar> db;

  ChatService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [ChatMessageSchema],
        directory: dir.path,
      );
    }
    return Isar.getInstance()!;
  }

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

  Future<List<ChatMessage>> getAllMessages() async {
    final isar = await db;
    return await isar.chatMessages.where().sortByTimestamp().findAll();
  }

  Future<void> clearHistory() async {
    final isar = await db;
    await isar.writeTxn(() => isar.chatMessages.clear());
  }
}