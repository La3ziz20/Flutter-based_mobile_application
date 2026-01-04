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
  String get settingsTitle => 'Settings';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get ecoHeroTitle => 'Eco Hero';

  @override
  String ecoHeroScore(Object score) {
    return 'Score: $score';
  }

  @override
  String get climateCombatTitle => 'Smog Buster';

  @override
  String get cityChallengeTitle => 'Waste Catcher';

  @override
  String get tapToPlay => 'Tap to Play';

  @override
  String get gameOver => 'Game Over';

  @override
  String get paused => 'Paused';

  @override
  String get plantTrees => 'Plant Trees (-CO2)';

  @override
  String get buildIndustry => 'Build Industry (+CO2)';

  @override
  String get guestUser => 'Guest Eco-Warrior';

  @override
  String get dailyEcoTipTitle => 'Daily Eco Tip';

  @override
  String get dailyEcoTipContent =>
      'Did you know? Recycling one aluminum can saves enough energy to run a TV for 3 hours!';

  @override
  String get playAndLearn => 'Play & Learn';

  @override
  String get ecoHeroDesc => 'Clean the world!';

  @override
  String get smogBusterDesc => 'Strategy for change.';

  @override
  String get wasteCatcherDesc => 'Build the future.';

  @override
  String timeLabel(Object time) {
    return 'Time: $time s';
  }

  @override
  String highScoreLabel(Object score) {
    return 'High: $score';
  }

  @override
  String co2Label(Object value) {
    return 'CO2: $value ppm';
  }

  @override
  String tempLabel(Object value) {
    return 'Temp: $value°C';
  }

  @override
  String get ok => 'OK';

  @override
  String gameOverMessage(Object highScore, Object score) {
    return 'Your Score: $score\nHigh Score: $highScore';
  }

  @override
  String get chatTitle => 'Eco Chat';

  @override
  String get chatHint => 'Ask me about nature...';

  @override
  String get botGreeting => 'Hello! I\'m here to help you save the planet.';

  @override
  String get send => 'Send';

  @override
  String get you => 'You';

  @override
  String get ecoBot => 'Eco Bot';
}
