import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projet_mobile/l10n/generated/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.changeLanguage),
            trailing: DropdownButton<String>(
              value: localeProvider.locale.languageCode,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
              ],
              onChanged: (val) {
                if (val != null) {
                  localeProvider.setLocale(Locale(val));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
