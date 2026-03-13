import 'package:isar/isar.dart';

// Nama file ini harus sama dengan nama file .dart kamu (misal: chat_message.dart)
part 'chat_message.g.dart'; 

@collection
class ChatMessage {
  Id id = Isar.autoIncrement; // Isar.autoIncrement butuh import isar.dart

  @Index()
  late String text;

  late DateTime timestamp;
  
  late bool isUser;
  bool isSynced = false;
}