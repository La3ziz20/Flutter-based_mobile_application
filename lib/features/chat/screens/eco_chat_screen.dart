import 'dart:math';
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
    final languageCode = Localizations.localeOf(context).languageCode;
    final isArabic = languageCode == 'ar';
    final lowerInput = input.toLowerCase();
    final random = Random();

    // Data for English responses
    final Map<String, List<String>> englishResponses = {
      'plastic': [
        "Plastic takes 450+ years to decompose. Use reusable bags!",
        "Did you know 91% of plastic isn't recycled? Reduce usage where possible.",
        "Avoid single-use plastics like straws and cutlery to save marine life."
      ],
      'water': [
        "Turn off the tap while brushing to save ~6 liters/minute!",
        "Fix leaky faucets. A drip can waste 10,000+ liters a year.",
        "Take shorter showers to save both water and the energy used to heat it."
      ],
      'tree': [
        "A single mature tree can release enough oxygen for two people.",
        "Trees cool the streets and break up urban heat islands.",
        "Planting a tree is a long-term investment in the planet's health."
      ],
      'energy': [
        "Switch to LED bulbs; they use 75% less energy than incandescent ones.",
        "Unplug electronics when not in use to stop 'vampire' energy drain.",
        "Wash clothes in cold water to save significant heating energy."
      ],
      'recycle': [
        "Rinse your recyclables! Food residue can ruin a whole batch.",
        "Check local guidelines. Not all plastics are recyclable everywhere.",
        "Recycling aluminum saves 95% of the energy needed to make new aluminum."
      ],
      'food': [
        "Eat more plant-based meals to lower your carbon footprint.",
        "Reduce food waste by composting scraps.",
        "Buy local to reduce emission from food transportation."
      ],
      'hello': [
        "Hello there! Ready to be an Eco Hero today?",
        "Hi! How can I help you live more sustainably?",
        "Greetings! Let's talk about saving the planet."
      ]
    };

    final List<String> englishDefaults = [
      "That's interesting! Every small eco-step counts.",
      "Could you tell me more? I love learning about eco-habits.",
      "Remember, simple acts like turning off lights make a difference!",
      "I'm still learning, but I'd love to discuss nature or recycling.",
      "Did you know changing your diet can help the climate too?"
    ];

    // Data for Arabic responses
    final Map<String, List<String>> arabicResponses = {
      'بلاستيك': [
        "يستغرق البلاستيك أكثر من 450 عاماً ليتحلل. استخدم أكياس قابلة لإعادة الاستخدام!",
        "هل تعلم أن 91٪ من البلاستيك لا يتم إعادة تدويره؟ قلل استهلاكك.",
        "تجنب المواد البلاستيكية ذات الاستخدام الواحد مثل المصاصات لحماية الحياة البحرية."
      ],
      'ماء': [
        "أغلق الصنبور أثناء تنظيف أسنانك لتوفير حوالي 6 لترات في الدقيقة!",
        "أصلح الصنابير المسربة. التنقيط يمكن أن يهدر آلاف اللترات سنوياً.",
        "خذ حماماً أقصر لتوفير المياه والطاقة المستخدمة لتسخينها."
      ],
      'شجرة': [
        "يمكن لشجرة ناضجة واحدة إنتاج ما يكفي من الأكسجين لشخصين.",
        "الأشجار تبرد الشوارع وتقلل من حرارة المدن.",
        "زراعة شجرة هو استثمار طويل الأجل في صحة كوكبنا."
      ],
      'طاقة': [
        "استبدل المصابيح بـ LED؛ فهي تستهلك طاقة أقل بنسبة 75٪.",
        "افصل الأجهزة الإلكترونية عند عدم استخدامها لوقف هدر الطاقة.",
        "اغسل الملابس بالماء البارد لتوفير طاقة التسخين."
      ],
      'تدوير': [
        "اشطف المواد القابلة لإعادة التدوير! بقايا الطعام يمكن أن تفسد الدفعة بكملها.",
        "تحقق من القواعد المحلية. ليس كل البلاستيك قابل للتدوير في كل مكان.",
        "إعادة تدوير الألومنيوم يوفر 95٪ من الطاقة اللازمة لصنع ألومنيوم جديد."
      ],
      'طعام': [
        "تناول وجبات نباتية أكثر لتقليل بصمتك الكربونية.",
        "قلل من هدر الطعام عن طريق تحويل البقايا إلى سماد.",
        "اشتري محلياً لتقليل انبعاثات نقل الغذاء."
      ],
      'مرحبا': [
        "مرحباً بك! هل أنت مستعد لتكون بطلاً للبيئة اليوم؟",
        "أهلاً! كيف يمكنني مساعدتك لتعيش حياة أكثر استدامة؟",
        "تحياتي! دعنا نتحدث عن حماية الكوكب."
      ]
    };

    final List<String> arabicDefaults = [
      "هذا مثير للاهتمام! كل خطوة بيئية صغيرة تحدث فرقاً.",
      "هل يمكنك إخباري بالمزيد؟ أحب تعلم عادات بيئية جديدة.",
      "تذكر، أفعال بسيطة مثل إطفاء الأنوار تصنع فرقاً!",
      "ما زلت أتعلم، لكني أحب مناقشة الطبيعة أو إعادة التدوير.",
      "هل تعلم أن تغيير نظامك الغذائي يمكن أن يساعد المناخ أيضاً؟"
    ];

    
    final responsesMap = isArabic ? arabicResponses : englishResponses;
    final defaults = isArabic ? arabicDefaults : englishDefaults;

    for (var entry in responsesMap.entries) {
      // Check if input matches keyword (simple contains check)
      // Note: For Arabic 'contains' might be tricky with variations, but keeping it simple as requested.
      if (lowerInput.contains(entry.key.toLowerCase())) {
         return entry.value[random.nextInt(entry.value.length)];
      }
    }
    
    // Also check mapped counterparts if identifying mixed language or exact translations is needed,
    // but for now relying on current locale is safest.
    // If we want to support 'plastic' input while in Arabic mode, we could enable cross-checking.
    // For now, adhere to the active locale to determine the response language.

    return defaults[random.nextInt(defaults.length)];
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
