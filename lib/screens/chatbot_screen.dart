import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'sender': 'bot',
      'message': 'Hello! I am AgroBot. Ask me anything about farming!',
    },
  ];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'user', 'message': _controller.text});
        _messages.add({
          'sender': 'bot',
          'message': _getResponse(_controller.text),
        });
      });
      _controller.clear();
    }
  }

  String _getResponse(String query) {
    // Hardcoded responses for farming-related questions
    query = query.toLowerCase();
    if (query.contains('crop') && query.contains('suggestion')) {
      return 'For crop suggestions, consider soil type, climate, and market demand. Common crops include wheat, rice, and maize.';
    } else if (query.contains('disease') || query.contains('pest')) {
      return 'To detect diseases, check for unusual spots or wilting. Use our disease detection feature for accurate diagnosis.';
    } else if (query.contains('weather')) {
      return 'Weather affects farming greatly. Check local forecasts and plan irrigation accordingly.';
    } else if (query.contains('market') || query.contains('price')) {
      return 'Market prices vary. Use our market prices section to get the latest updates.';
    } else {
      return 'I\'m here to help with farming questions. Try asking about crops, diseases, or weather!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.chatbot)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment:
                      message['sender'] == 'user'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    margin: EdgeInsets.only(
                      top: index == 0 ? 16 : 2,
                      bottom: 2,
                      left: 8,
                      right: 8,
                    ),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color:
                          message['sender'] == 'user'
                              ? AppTheme.primaryBrown
                              : AppTheme.lightCream,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message['message']!,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            message['sender'] == 'user'
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask about farming...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: AppTheme.primaryBrown,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
