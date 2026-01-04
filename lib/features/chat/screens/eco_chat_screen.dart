import 'package:flutter/material.dart';
import 'package:projet_mobile/l10n/generated/app_localizations.dart';
import '../../../core/theme/eco_theme.dart';

class EcoChatScreen extends StatefulWidget {
  const EcoChatScreen({super.key});

  @override
  State<EcoChatScreen> createState() => _EcoChatScreenState();
}

class _EcoChatScreenState extends State<EcoChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_messages.isEmpty) {
      // Add initial greeting
      _addBotMessage(AppLocalizations.of(context)!.botGreeting);
    }
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _controller.clear();
    _addUserMessage(text);

    // Simulate thinking delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _addBotMessage(_getBotResponse(text));
      }
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        sender: AppLocalizations.of(context)!.you,
      ));
    });
    _scrollToBottom();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: false,
        sender: AppLocalizations.of(context)!.ecoBot,
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getBotResponse(String input) {
    final lowerInput = input.toLowerCase();
    
    // Simple keyword matching for demo purposes
    if (lowerInput.contains('plastic') || lowerInput.contains('plastique') || lowerInput.contains('بلاستيك')) {
      return "Plastic takes hundreds of years to decompose. Try using reusable bags and bottles!";
    } else if (lowerInput.contains('water') || lowerInput.contains('eau') || lowerInput.contains('ماء')) {
      return "Conserving water is crucial. Turn off the tap while brushing your teeth to save liters of water.";
    } else if (lowerInput.contains('tree') || lowerInput.contains('arbre') || lowerInput.contains('شجرة')) {
      return "Trees absorb CO2 and release oxygen. Planting a tree is one of the best things you can do!";
    } else if (lowerInput.contains('energy') || lowerInput.contains('energie') || lowerInput.contains('طاقة')) {
      return "Switching to LED bulbs and turning off lights when not needed helps save energy.";
    } else if (lowerInput.contains('hello') || lowerInput.contains('hi') || lowerInput.contains('مرحبا')) {
      return "Hello there! Ready to save the planet?";
    }

    return "That's an interesting topic! Remember, every small action counts towards a greener future.";
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chatTitle),
        backgroundColor: EcoTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: l10n.chatHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onSubmitted: _handleSubmitted,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: EcoTheme.primaryGreen,
                  onPressed: () => _handleSubmitted(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final String sender;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              backgroundColor: EcoTheme.lightGreen,
              child: Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  sender,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser ? EcoTheme.primaryGreen : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(2),
                      bottomRight: isUser ? const Radius.circular(2) : const Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(color: isUser ? Colors.white : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: EcoTheme.oceanBlue,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}
