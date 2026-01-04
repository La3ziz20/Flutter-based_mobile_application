  import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:firebase_core/firebase_core.dart'; // TODO: Uncomment when google-services.json is added
import 'package:provider/provider.dart';
import 'package:projet_mobile/l10n/generated/app_localizations.dart';

import 'core/theme/eco_theme.dart';
import 'core/services/auth_service.dart';
import 'features/auth/screens/splash_screen.dart';
import 'core/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); 
  
  runApp(const EcoGameApp());
}

class EcoGameApp extends StatelessWidget {
  const EcoGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Eco Game Suite',
            debugShowCheckedModeBanner: false,
            theme: EcoTheme.lightTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            locale: localeProvider.locale,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
