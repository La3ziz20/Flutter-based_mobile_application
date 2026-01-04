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
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';
}
