import 'package:isar/isar.dart';

part 'chat_message.g.dart';

@collection
class ChatMessage {
  Id id = Isar.autoIncrement;

  @Index()
  late String sessionId;
  late String senderType; 
  late String message;
  late DateTime timestamp;
  bool isSynced = false;
}