import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_mobile/l10n/generated/app_localizations.dart';
import 'climate_combat_game.dart';

class ClimateCombatGameScreen extends StatefulWidget {
  const ClimateCombatGameScreen({super.key});

  @override
  State<ClimateCombatGameScreen> createState() => _ClimateCombatGameScreenState();
}

class _ClimateCombatGameScreenState extends State<ClimateCombatGameScreen> {
  int _co2 = 50;
  int _temp = 15;
  int _highScore = 0;
  int _currentScore = 0;
  String _timeLeft = "60";
  late ClimateCombatGame _game;
  
  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt('climate_combat_highscore') ?? 0;
    });
  }

  Future<void> _saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    if (score > _highScore) {
      await prefs.setInt('climate_combat_highscore', score);
      setState(() {
        _highScore = score;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _game = ClimateCombatGame(
      plantTreesLabel: AppLocalizations.of(context)!.plantTrees,
      industrialGrowthLabel: AppLocalizations.of(context)!.buildIndustry,
      onGameStateChanged: (co2, temp) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _co2 = co2;
              _temp = temp;
              _currentScore = _game.score;
              _timeLeft = _game.remainingTime.ceil().toString();
            });
          }
        });
      },
      onGameEnd: (score) {
        _saveHighScore(score);
        if (mounted) {
           showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.gameOver),
              content: Text(AppLocalizations.of(context)!.gameOverMessage(score, _highScore)),
              actions: [
                TextButton(
                  onPressed: () {
                     Navigator.of(ctx).pop();
                     Navigator.of(context).pop(); // Go back to menu
                  },
                  child: Text(AppLocalizations.of(context)!.ok),
                )
              ],
            ),
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.climateCombatTitle)),
      body: Stack(
        children: [
          GameWidget(game: _game),
           Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    "${AppLocalizations.of(context)!.co2Label(_co2)} | ${AppLocalizations.of(context)!.tempLabel(_temp)}", 
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.timeLabel(_timeLeft),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent
                    ),
                  ),
                   const SizedBox(height: 4),
                  Text(
                    "${AppLocalizations.of(context)!.ecoHeroScore(_currentScore)} | ${AppLocalizations.of(context)!.highScoreLabel(_highScore)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
