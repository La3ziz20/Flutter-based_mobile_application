import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'water_cleanup_game.dart';

class WaterCleanupScreen extends StatefulWidget {
  const WaterCleanupScreen({super.key});

  @override
  State<WaterCleanupScreen> createState() => _WaterCleanupScreenState();
}

class _WaterCleanupScreenState extends State<WaterCleanupScreen> {
  int _score = 0;
  int _timeLeft = 60;
  late WaterCleanupGame _game;

  @override
  void initState() {
    super.initState();
    _game = WaterCleanupGame(
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
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: const Text("Game Over"),
              content: Text("Mission Complete!\nCleanup Score: $finalScore"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Awesome!"),
                )
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Water Cleanup")),
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
                    "Time: $_timeLeft",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft < 10 ? Colors.red : Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Cleaned: $_score",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Drag boat to collect trash and oil! Avoid Wildlife!",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, backgroundColor: Colors.black45),
              ),
            ),
          )
        ],
      ),
    );
  }
}
