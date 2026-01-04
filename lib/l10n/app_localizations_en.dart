// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Eco Game Suite';

  @override
  String get welcomeMessage => 'Welcome to Eco Hero!';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get guestMode => 'Continue as Guest';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get ecoPoints => 'Eco Points';

  @override
  String get play => 'Play';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';
}
