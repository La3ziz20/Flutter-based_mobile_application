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
  
  // Simulated AI Logic
  final _SimulatedEcoBot _bot = _SimulatedEcoBot();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_messages.isEmpty) {
      _addBotMessage(AppLocalizations.of(context)!.botGreeting);
    }
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _controller.clear();
    _addUserMessage(text);

    // Simulate "thinking" time for realism
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        final languageCode = Localizations.localeOf(context).languageCode;
        final response = _bot.getResponse(text, languageCode);
        _addBotMessage(response);
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

// -----------------------------------------------------------------------------
// SIMULATED AI ENGINE
// -----------------------------------------------------------------------------
class _SimulatedEcoBot {
  final Random _random = Random();

  String getResponse(String input, String languageCode) {
    final isArabic = languageCode == 'ar';
    final normalizedInput = input.toLowerCase().trim();

    // 1. GREETINGS & SMALL TALK
    if (_matches(normalizedInput, ['hello', 'hi', 'hey', 'greetings', 'hola'], ['مرحبا', 'أهلا', 'هلا', 'سلام'])) {
      return isArabic 
        ? "أهلاً بك يا صديق البيئة! كيف يمكنني مساعدتك في حماية كوكبنا اليوم؟"
        : "Hello, Eco-Warrior! How can I help you save our planet today?";
    }
    
    if (_matches(normalizedInput, ['how are you', 'how r u'], ['كيف حالك', 'شلونك'])) {
      return isArabic
        ? "أنا مجرد ذكاء اصطناعي، لكني أشعر بانتعاش كلما قام أحد بإعادة التدوير! ماذا عنك؟"
        : "I'm just code, but I feel refreshed every time someone recycles! How are you?";
    }

    if (_matches(normalizedInput, ['who are you', 'what are you'], ['من انت', 'ما انت', 'عرف نفسك'])) {
      return isArabic
        ? "أنا مساعدك البيئي الذكي! موجود هنا لأجيب عن أسئلتك حول المناخ، التدوير، وكيفية العيش باستدامة."
        : "I am your smart Eco-Assistant! I'm here to answer questions about climate, recycling, and sustainable living.";
    }

    // 2. SPECIFIC TOPICS (Expanded Knowledge Base)
    
    // PLASTIC
    if (_matches(normalizedInput, ['plastic', 'bottle', 'bag'], ['بلاستيك', 'قنينة', 'كيس'])) {
      final facts = isArabic ? [
        "البلاستيك يحتاج 450 سنة ليتحلل! جرب استخدام قارورة مياه معدنية قابلة لإعادة التعبئة.",
        "هل تعلم؟ معظم فرش الأسنان البلاستيكية التي صنعت لازالت موجودة حتى اليوم. فكر في البدائل!",
        "إعادة تدوير قنينة بلاستيكية واحدة يوفر طاقة تكفي لتشغيل مصباح لمدة 6 ساعات."
      ] : [
        "Plastic takes 450 years to decompose! Try carrying a reusable water bottle.",
        "Fun fact: Recycling one plastic bottle saves enough energy to power a lightbulb for 6 hours.",
        "Did you know? Microplastics are now found even in the deepest oceans. Reducing usage is better than recycling."
      ];
      return facts[_random.nextInt(facts.length)];
    }

    // WATER
    if (_matches(normalizedInput, ['water', 'drink', 'shower', 'bath'], ['ماء', 'مياه', 'شرب', 'دوش', 'حمام'])) {
      return isArabic
        ? "الماء نعمة! هل تعلم أن تقليص وقت الاستحمام بدقيقة واحدة يوفر مئات اللترات شهريًا؟"
        : "Water is precious! Did you know cutting your shower time by just 1 minute saves hundreds of liters a month?";
    }

    // CLIMATE CHANGE
    if (_matches(normalizedInput, ['climate', 'change', 'global warming', 'heat'], ['مناخ', 'تغير', 'احتباس', 'حرارة'])) {
       return isArabic
        ? "التغير المناخي حقيقي، لكن الأمل موجود. استخدام الطاقة النظيفة وتقليل الهدر هما مفتاح الحل."
        : "Climate change is the biggest challenge of our time. But every solar panel and planted tree helps fight it!";
    }

    // RECYCLING (General)
    if (_matches(normalizedInput, ['recycle', 'recycling', 'bin', 'sort'], ['تدوير', 'اعادة', 'فرز', 'قمامة'])) {
      return isArabic
        ? "التدوير فن! تأكد دائماً من غسل العبوات قبل رميها في حاوية إعادة التدوير لضمان جودتها."
        : "Recycling is an art! Always make sure to rinse your containers before binning them to avoid contamination.";
    }

    // TREES / NATURE
    if (_matches(normalizedInput, ['tree', 'forest', 'plant', 'nature'], ['شجرة', 'غابة', 'نبات', 'طبيعة'])) {
      return isArabic
        ? "الأشجار هي رئة الأرض. زراعة شجرة واحدة تمتص حوالي 22 كيلوغراماً من ثاني أكسيد الكربون سنوياً!"
        : "Trees are the Earth's lungs. Planting just one tree absorbs about 22kg of CO2 per year!";
    }

    // ENERGY
    if (_matches(normalizedInput, ['energy', 'electric', 'light', 'solar'], ['طاقة', 'كهرباء', 'ضوء', 'شمس'])) {
      return isArabic
        ? "أطفئ الأنوار عند مغادرة الغرفة! هذا الفعل البسيط يوفر الطاقة ويقلل فاتورتك."
        : "Turn off the lights when you leave a room! It's the simplest way to save energy and money.";
    }

     // FOOD
    if (_matches(normalizedInput, ['food', 'eat', 'meat', 'vegan'], ['طعام', 'أكل', 'لحم', 'خضار'])) {
      return isArabic
        ? "حاول تقليل هدر الطعام. بقايا الطعام في المكبات تنتج غاز الميثان الضار جداً."
        : "Try to reduce food waste. Rotting food in landfills produces methane, a potent greenhouse gas.";
    }

    // 3. FALLBACK / "SMART" DEFAULT
    // If no specific keyword is found, return a generic but relevant eco-tip or encouraging remark.
    if (isArabic) {
      final defaults = [
        "سؤال جيد! بشكل عام، كلما قللنا استهلاكنا، كلما ساعدنا الكوكب أكثر.",
        "لست متأكداً تماماً، ولكن تذكر القاعدة الذهبية: قلل، أعد الاستخدام، ثم أعد التدوير.",
        "همم.. هذا موضوع عميق. لكن المؤكد أن الطبيعة تحتاجنا جميعاً.",
        "هل يمكنك صياغة ذلك بطريقة أخرى؟ أنا أتعلم كل يوم لأصبح مساعداً أفضل!",
        "البيئة تتأثر بكل قرار نتخذه. شكراً لاهتمامك!"
      ];
      return defaults[_random.nextInt(defaults.length)];
    } else {
      final defaults = [
        "That's a great point! Generally, the less we consume, the more we help the planet.",
        "I'm not 100% sure on that specific detail, but remember the Golden Rule: Reduce, Reuse, Recycle.",
        "Hmm, interesting topic. Nature relies on us to make conscious choices every day.",
        "Could you rephrase that? I'm still learning to be the best Eco-Bot I can be!",
        "Every decision acts as a vote for the kind of world we want to live in. Thanks for caring!"
      ];
      return defaults[_random.nextInt(defaults.length)];
    }
  }

  bool _matches(String input, List<String> eng, List<String> ara) {
    for (var w in eng) {
      if (input.contains(w)) return true;
    }
    for (var w in ara) {
      if (input.contains(w)) return true;
    }
    return false;
  }
}
