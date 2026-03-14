import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'chat_service.dart';

class SyncService {
  final ChatService _chatService = ChatService();
  final String _serverUrl = "https://api.gaiaconnect.dev/sync"; // Sesuaikan URL servermu

  Future<void> syncPendingMessages() async {
    // 1. Cek Koneksi Internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) return;

    // 2. Ambil pesan yang belum tersinkron
    final pendingMessages = await _chatService.getUnsyncedMessages();
    if (pendingMessages.isEmpty) return;

    for (var msg in pendingMessages) {
      try {
        final response = await http.post(
          Uri.parse(_serverUrl),
          body: jsonEncode({
            'content': msg.content,
            'isUser': msg.isUser,
            'timestamp': msg.timestamp.toIso8601String(),
          }),
        );

        if (response.statusCode == 200) {
          // 3. Update status di Isar jika sukses
          msg.isSynced = true;
          await _chatService.updateMessageSyncStatus(msg);
        }
      } catch (e) {
        print("Gagal sync: $e");
      }
    }
  }
}