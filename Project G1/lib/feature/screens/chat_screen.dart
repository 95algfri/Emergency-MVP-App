import 'package:flutter/material.dart';
import '../../Data/Models/chat_message.dart';
import '../../Data/Services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // Mengambil riwayat dari Isar
  void _loadMessages() async {
    final messages = await _chatService.getAllMessages();
    setState(() {
      _messages = messages;
    });
  }

  
  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    String userText = _controller.text;
    _controller.clear();

    await _chatService.saveMessage(userText, true);
    _loadMessages();

    _generateAIResponse(userText);
  }

  void _generateAIResponse(String prompt) async {
    await Future.delayed(const Duration(seconds: 1));
    await _chatService.saveMessage("RagaBhumi siap membantu terkait: $prompt", false);
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("RagaBhumi AI"),
        backgroundColor: const Color(0xFF1F1F1F),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(msg);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: msg.isUser ? Colors.blueGrey[800] : Colors.grey[900],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white10),
        ),
        child: Text(
          msg.text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color(0xFF1F1F1F),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Tanya Gaia Connect...",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blueAccent),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}