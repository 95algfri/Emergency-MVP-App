import 'package:flutter/material.dart';
import 'dart:ui';
import '../../feature/screens/chat_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
        
          Positioned(
            top: -50, right: -50,
            child: Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue.withOpacity(0.3))),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Gaia Connect", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  
                  Expanded(
                    child: GridView.count(
                        child: _buildGlassCard(
    .                     "RagaBhumi AI", 
                          "Tanya AI", 
                          "Mode Offline Aktif", 
                         const [Color(0xFF667EEA), Color(0xFF764BA2)],
                         isAction: true, // Tambahkan parameter untuk memberi visual tambahan
                         ),
                      ),
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: [
                        _buildGlassCard("Status Banjir", "100%", "Aman", const [Color(0xFF333D72), Color(0xFF5E9AFB)]),
                        _buildGlassCard("Gempa Terkini", "4.5 SR", "Luar Kota", const [Color(0xFFE580A7), Color(0xFFFB9A5E)]),
                        _buildGlassCard("Oksigen", "98%", "Normal", const [Color(0xFF43E97B), Color(0xFF38F9D7)]),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ChatScreen()),
                              );
                            },
                          child: _buildGlassCard(
                            "RagaBhumi AI", 
                            "Tanya AI", 
                            "Mode Offline Aktif", 
                            const [Color(0xFF667EEA), Color(0xFF764BA2)],
                            isAction: true, // Berikan indikator panah
                             ),
                           ),
                         ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard(String title, String value, String sub, List<Color> colors) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors.map((c) => c.withOpacity(0.6)).toList()),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 10),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              Text(sub, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}