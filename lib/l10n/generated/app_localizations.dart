import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Eco Game Suite'**
  String get appTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Eco Hero!'**
  String get welcomeMessage;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @guestMode.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get guestMode;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @ecoPoints.
  ///
  /// In en, this message translates to:
  /// **'Eco Points'**
  String get ecoPoints;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @ecoHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Eco Hero'**
  String get ecoHeroTitle;

  /// No description provided for @ecoHeroScore.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String ecoHeroScore(Object score);

  /// No description provided for @climateCombatTitle.
  ///
  /// In en, this message translates to:
  /// **'Smog Buster'**
  String get climateCombatTitle;

  /// No description provided for @cityChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Waste Catcher'**
  String get cityChallengeTitle;

  /// No description provided for @tapToPlay.
  ///
  /// In en, this message translates to:
  /// **'Tap to Play'**
  String get tapToPlay;

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @plantTrees.
  ///
  /// In en, this message translates to:
  /// **'Plant Trees (-CO2)'**
  String get plantTrees;

  /// No description provided for @buildIndustry.
  ///
  /// In en, this message translates to:
  /// **'Build Industry (+CO2)'**
  String get buildIndustry;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest Eco-Warrior'**
  String get guestUser;

  /// No description provided for @dailyEcoTipTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Eco Tip'**
  String get dailyEcoTipTitle;

  /// No description provided for @dailyEcoTipContent.
  ///
  /// In en, this message translates to:
  /// **'Did you know? Recycling one aluminum can saves enough energy to run a TV for 3 hours!'**
  String get dailyEcoTipContent;

  /// No description provided for @playAndLearn.
  ///
  /// In en, this message translates to:
  /// **'Play & Learn'**
  String get playAndLearn;

  /// No description provided for @ecoHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'Clean the world!'**
  String get ecoHeroDesc;

  /// No description provided for @smogBusterDesc.
  ///
  /// In en, this message translates to:
  /// **'Strategy for change.'**
  String get smogBusterDesc;

  /// No description provided for @wasteCatcherDesc.
  ///
  /// In en, this message translates to:
  /// **'Build the future.'**
  String get wasteCatcherDesc;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time: {time} s'**
  String timeLabel(Object time);

  /// No description provided for @highScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'High: {score}'**
  String highScoreLabel(Object score);

  /// No description provided for @co2Label.
  ///
  /// In en, this message translates to:
  /// **'CO2: {value} ppm'**
  String co2Label(Object value);

  /// No description provided for @tempLabel.
  ///
  /// In en, this message translates to:
  /// **'Temp: {value}°C'**
  String tempLabel(Object value);

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @gameOverMessage.
  ///
  /// In en, this message translates to:
  /// **'Your Score: {score}\nHigh Score: {highScore}'**
  String gameOverMessage(Object highScore, Object score);

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Eco Chat'**
  String get chatTitle;

  /// No description provided for @chatHint.
  ///
  /// In en, this message translates to:
  /// **'Ask me about nature...'**
  String get chatHint;

  /// No description provided for @botGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m here to help you save the planet.'**
  String get botGreeting;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @ecoBot.
  ///
  /// In en, this message translates to:
  /// **'Eco Bot'**
  String get ecoBot;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
