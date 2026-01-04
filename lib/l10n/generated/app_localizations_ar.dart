// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مجموعة الألعاب البيئية';

  @override
  String get welcomeMessage => 'مرحباً بك في بطل البيئة!';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get guestMode => 'المتابعة كضيف';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get ecoPoints => 'النقاط البيئية';

  @override
  String get play => 'العب';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get ecoHeroTitle => 'بطل البيئة';

  @override
  String ecoHeroScore(Object score) {
    return 'النقاط: $score';
  }

  @override
  String get climateCombatTitle => 'مكافح التلوث';

  @override
  String get cityChallengeTitle => 'جامع النفايات';

  @override
  String get tapToPlay => 'انقر للعب';

  @override
  String get gameOver => 'انتهت اللعبة';

  @override
  String get paused => 'موقوف';

  @override
  String get plantTrees => 'ازرع شجرة (-CO2)';

  @override
  String get buildIndustry => 'بناء مصنع (+CO2)';

  @override
  String get guestUser => 'محارب بيئي ضيف';

  @override
  String get dailyEcoTipTitle => 'نصيحة بيئية يومية';

  @override
  String get dailyEcoTipContent =>
      'هل تعلم؟ إعادة تدوير علبة ألومنيوم واحدة يوفر طاقة كافية لتشغيل تلفاز لمدة 3 ساعات!';

  @override
  String get playAndLearn => 'العب وتعلم';

  @override
  String get ecoHeroDesc => 'نظف العالم!';

  @override
  String get smogBusterDesc => 'استراتيجية للتغيير.';

  @override
  String get wasteCatcherDesc => 'ابنِ المستقبل.';

  @override
  String timeLabel(Object time) {
    return 'الوقت: $time ث';
  }

  @override
  String highScoreLabel(Object score) {
    return 'الأفضل: $score';
  }

  @override
  String co2Label(Object value) {
    return 'ثاني أكسيد الكربون: $value جزء بالمليون';
  }

  @override
  String tempLabel(Object value) {
    return 'الحرارة: $value درجة مئوية';
  }

  @override
  String get ok => 'حسناً';

  @override
  String gameOverMessage(Object highScore, Object score) {
    return 'نقاطك: $score\nأفضل نقاط: $highScore';
  }

  @override
  String get chatTitle => 'المحادثة البيئية';

  @override
  String get chatHint => 'اسألني عن الطبيعة...';

  @override
  String get botGreeting => 'مرحباً! أنا هنا لمساعدتك في حماية الكوكب.';

  @override
  String get send => 'إرسال';

  @override
  String get you => 'أنت';

  @override
  String get ecoBot => 'بوت البيئة';
}
