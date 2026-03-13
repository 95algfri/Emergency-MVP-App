import 'package:flutter/material.dart';
import 'dart:ui';
import '../../data/Models/chat_message.dart';
import '../../data/Services/chat_service.dart';
import '../../data/Services/ai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _generateAIResponse(String userPrompt) async {
    try {
      String aiResponse = await _aiService.getResponse(userPrompt);
    
      await _chatService.saveMessage(aiResponse, false);
      _loadMessages();
    } catch (e) {
      print("Error AI: $e");
      await _chatService.saveMessage("Maaf, RagaBhumi sedang mengalami kendala teknis.", false);
      _loadMessages();
    }
  }

  final ChatService _chatService = ChatService();
  final AIService _aiService = AIService();

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    final messages = await _chatService.getAllMessages();
    setState(() {
      _messages = messages;
    });

    _scrollToBottom();
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
    setState(() {
    _isLoading = true;
    });

    try {
    String aiResponse = await _aiService.getResponse(userPrompt);
    await _chatService.saveMessage(aiResponse, false);
    _loadMessages();
  } catch (e) {
    await _chatService.saveMessage("Maaf, terjadi kendala teknis.", false);
    _loadMessages();
  } finally {
    setState(() {
      _isLoading = false;
    });
  }

  void _scrollToBottom() {
  // Tunggu sampai frame selesai dirender
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), // Kecepatan geser
        curve: Curves.easeOut, // Efek pergerakan
      );
    }
  });
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
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildTypingIndicator();
                }
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

  Widget _buildTypingIndicator() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        "RagaBhumi sedang berpikir...",
        style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic, fontSize: 12),
      ),
    ),
  );
}

  Widget _buildChatBubble(ChatMessage message) {
  final isUser = message.isUser;
  
  final userGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE580A7),
      Color(0xFFFB9A5E),
    ],
  );

  final aiGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF333D72),
      Color(0xFFFB9A5E),
    ],
  );

  return Align(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        // Radius sudut yang besar untuk bentuk persegi panjang yang membulat (1/2, 2/3, dll)
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: Radius.circular(isUser ? 0 : 20),
          bottomLeft: const Radius.circular(20),
          bottomRight: Radius.circular(isUser ? 20 : 0),
        ),
        child: BackdropFilter(
          // Efek Kaca Buram
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 0.7, // Batasi lebar bubble
            decoration: BoxDecoration(
              // Latar belakang gradien semi-transparan
              gradient: isUser ? userGradient : aiGradient,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: Radius.circular(isUser ? 0 : 20),
                bottomLeft: const Radius.circular(20),
                bottomRight: Radius.circular(isUser ? 20 : 0),
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.1), // Garis tepi tipis semi-transparan
                width: 1.0,
              ),
            ),
            child: Text(
              message.content,
              style: TextStyle(
                // Warna teks putih dengan sedikit transparansi
                color: Colors.white.withOpacity(0.9), 
                fontSize: 14,
              ),
            ),
          ),
        ),
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