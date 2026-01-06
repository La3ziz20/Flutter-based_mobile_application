import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projet_mobile/l10n/generated/app_localizations.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/eco_theme.dart';
import '../../auth/screens/welcome_screen.dart';
import '../../games/eco_hero/eco_hero_screen.dart';
import '../../games/climate_combat/climate_combat_screen.dart';
import '../../games/city_challenge/city_challenge_screen.dart';


import '../../games/water_cleanup/water_cleanup_screen.dart';


import 'settings_screen.dart';
import '../../chat/screens/eco_chat_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context);
    
    // Mock user data
    final String userName = authService.user?.email?.split('@')[0] ?? l10n.guestUser;
    final int ecoPoints = 150; // TODO: Fetch from Firestore

    return Scaffold(
      backgroundColor: EcoTheme.sandBeige,
      appBar: AppBar(
        title: Text(l10n.dashboard),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Profile Card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: EcoTheme.lightGreen,
                        child: const Icon(Icons.person, size: 30, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${l10n.ecoPoints}: $ecoPoints",
                            style: theme.textTheme.bodyMedium?.copyWith(color: EcoTheme.darkGreen),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Daily Tip Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: EcoTheme.oceanBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: EcoTheme.oceanBlue.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb, color: EcoTheme.oceanBlue),
                        const SizedBox(width: 8),
                        Text(
                          l10n.dailyEcoTipTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: EcoTheme.oceanBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.dailyEcoTipContent,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                "Play & Learn",
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Game Cards
              _GameCard(
                title: l10n.ecoHeroTitle,
                description: l10n.ecoHeroDesc,
                icon: Icons.forest,
                color: EcoTheme.primaryGreen,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EcoHeroGameScreen())),
              ),
              const SizedBox(height: 12),
              _GameCard(
                title: l10n.climateCombatTitle,
                description: l10n.smogBusterDesc,
                icon: Icons.shield,
                color: EcoTheme.oceanBlue,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClimateCombatGameScreen())),
              ),
              const SizedBox(height: 12),
              _GameCard(
                title: l10n.cityChallengeTitle,
                description: l10n.wasteCatcherDesc,
                icon: Icons.location_city,
                color: Colors.orange,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CityChallengeGameScreen())),
              ),
              const SizedBox(height: 12),
              
              // New Levels

               _GameCard(
                title: "Water Cleanup",
                description: "Clean the ocean and save wildlife!",
                icon: Icons.water_drop,
                color: Colors.blueAccent,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WaterCleanupScreen())),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: EcoTheme.primaryGreen,
        child: const Icon(Icons.chat_bubble, color: Colors.white),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EcoChatScreen())),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GameCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
