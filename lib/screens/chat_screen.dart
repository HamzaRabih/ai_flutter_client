import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _imagePromptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [];
  File? _selectedImage;

  Future<void> _sendMessage() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': query});
    });
    _scrollToBottom();

    _queryController.clear();

    try {
      final response = _selectedImage != null
          ? await ApiService.sendImageQuery(query, _selectedImage!)
          : await ApiService.sendTextQuery(query);

      setState(() {
        _messages.add({'sender': 'ai', 'text': response});
      });
      _scrollToBottom();

    } catch (_) {
      setState(() {
        _messages.add({'sender': 'ai', 'text': '❌ Erreur de serveur.'});
      });
      _scrollToBottom();

    }

    _selectedImage = null;
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _generateImage() async {
    final prompt = _imagePromptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': '[GÉNÉRATION] $prompt'});
    });
    _scrollToBottom();

    try {
      final imageUrl = await ApiService.generateImage(prompt);
      setState(() {
        _messages.add({'sender': 'ai', 'text': '🖼️ Image générée :'});
        _messages.add({'sender': 'image', 'url': imageUrl});
      });
    } catch (_) {
      setState(() {
        _messages.add({'sender': 'ai', 'text': '❌ Erreur lors de la génération de l\'image.'});
      });
      _scrollToBottom();

    }

    _imagePromptController.clear();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
      _scrollToBottom();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🤖 Agent IA Multimodal")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];

                if (msg['sender'] == 'image') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.network(msg['url']),
                  );
                }

                return MessageBubble(
                  message: msg['text'] ?? '',
                  isMe: msg['sender'] == 'user',
                );
              },
            ),
          ),
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(_selectedImage!, height: 100),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _queryController,
                      decoration: const InputDecoration(
                        hintText: "Posez une question...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.image), onPressed: _pickImage),
                  IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _imagePromptController,
                      decoration: const InputDecoration(
                        hintText: "Décris une image à générer...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.auto_awesome), onPressed: _generateImage),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
