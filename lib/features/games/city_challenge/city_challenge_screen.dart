import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:projet_mobile/l10n/generated/app_localizations.dart';
import 'city_challenge_game.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CityChallengeGameScreen extends StatefulWidget {
  const CityChallengeGameScreen({super.key});

  @override
  State<CityChallengeGameScreen> createState() => _CityChallengeGameScreenState();
}

class _CityChallengeGameScreenState extends State<CityChallengeGameScreen> {
  int _score = 0;
  int _highScore = 0;
  int _timeLeft = 60;
  late CityChallengeGame _game;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _game = CityChallengeGame(
      onGameStateChanged: (score, time) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _score = score;
              _timeLeft = time;
            });
          }
        });
      },
      onGameEnd: (finalScore) {
        _saveHighScore(finalScore);
        if (mounted) {
           showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.gameOver),
              content: Text(AppLocalizations.of(context)!.gameOverMessage(finalScore, _highScore)),
              actions: [
                TextButton(
                  onPressed: () {
                     Navigator.of(ctx).pop();
                     Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.ok),
                )
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt('city_challenge_highscore') ?? 0;
    });
  }

  Future<void> _saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    if (score > _highScore) {
      await prefs.setInt('city_challenge_highscore', score);
      setState(() {
        _highScore = score;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.cityChallengeTitle)),
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
                    AppLocalizations.of(context)!.timeLabel(_timeLeft.toString()),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent
                    ),
                  ),
                   const SizedBox(height: 4),
                  Text(
                    "${AppLocalizations.of(context)!.ecoHeroScore(_score)} | ${AppLocalizations.of(context)!.highScoreLabel(_highScore)}",
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
