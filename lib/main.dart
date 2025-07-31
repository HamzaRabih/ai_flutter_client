import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const AgentIAApp());
}

class AgentIAApp extends StatelessWidget {
  const AgentIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agent IA Multimodal',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AgentIAApp());
}

class AgentIAApp extends StatelessWidget {
  const AgentIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agent IA Multimodal',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _imagePromptController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  File? _selectedImage;

  Future<void> _sendMessage() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': query});
    });

    _queryController.clear();

    try {
      final response = _selectedImage != null
          ? await _sendImageQuery(query, _selectedImage!)
          : await http.get(Uri.parse('http://192.168.1.100:8899/chat?query=$query'));

      setState(() {
        _messages.add({'sender': 'ai', 'text': response.body});
      });
    } catch (_) {
      setState(() {
        _messages.add({'sender': 'ai', 'text': '❌ Erreur de serveur.'});
      });
    }

    _selectedImage = null;
  }

  Future<http.Response> _sendImageQuery(String question, File image) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://192.168.1.100:8899/askImage'));
    request.fields['question'] = question;
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    final response = await http.Response.fromStream(await request.send());
    return response;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _generateImage() async {
    final prompt = _imagePromptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': '[GÉNÉRATION] $prompt'});
    });

    try {
      final response = await http.get(Uri.parse('http://192.168.1.100:8899/generateImage?promt=$prompt'));

      setState(() {
        _messages.add({'sender': 'ai', 'text': '🖼️ Image générée :'});
        _messages.add({'sender': 'image', 'url': response.body});
      });
    } catch (_) {
      setState(() {
        _messages.add({'sender': 'ai', 'text': '❌ Erreur lors de la génération de l\'image.'});
      });
    }

    _imagePromptController.clear();
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
                  return Image.network(msg['url']);
                }
                return Align(
                  alignment: msg['sender'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: msg['sender'] == 'user' ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(
                        color: msg['sender'] == 'user' ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
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
            child: Column(children: [
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
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
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
                IconButton(
                  icon: const Icon(Icons.auto_awesome),
                  onPressed: _generateImage,
                ),
              ]),
            ]),
          ),
        ],
      ),
    );
  }
}

 */