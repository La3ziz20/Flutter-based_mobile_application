import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'dart:math';

enum CloudType {
  smogLight(hp: 1, score: 10, color: Colors.grey),
  smogMedium(hp: 1, score: 20, color: Color(0xFF616161)), // Darker Grey, same HP but more points
  smogHeavy(hp: 2, score: 30, color: Color(0xFF424242)), // Very Dark Grey, 2 taps
  clean(hp: 1, score: -10, color: Colors.white), // Penalty
  bonus(hp: 1, score: 50, color: Colors.amber); // Power-up

  final int hp;
  final int score;
  final Color color;
  const CloudType({required this.hp, required this.score, required this.color});
}

class ClimateCombatGame extends FlameGame {
  final String plantTreesLabel;
  final String industrialGrowthLabel;
  
  final Function(int co2, int temp)? onGameStateChanged;
  final Function(int score)? onGameEnd;

  int score = 0;
  int co2Level = 0; 
  int globalTemp = 15; 
  double remainingTime = 60.0;
  double spawnTimer = 0.0;
  double spawnInterval = 1.8; // Slower start
  double speedMultiplier = 1.0;

  ClimateCombatGame({
    required this.plantTreesLabel, 
    required this.industrialGrowthLabel,
    this.onGameStateChanged,
    this.onGameEnd,
  });
  
  @override
  Future<void> onLoad() async {
    // Background
    add(SpriteComponent(
      sprite: await loadSprite('climate_combat_level_bg.png'),
      size: size,
    ));

    // Initial state
    updateGameState();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (remainingTime > 0) {
      remainingTime -= dt;
      spawnTimer += dt;
      
      // Difficulty Scaling
      double elapsed = 60 - remainingTime;
      speedMultiplier = 1.0 + (elapsed / 60.0) * 1.5; // Up to 2.5x speed
      spawnInterval = (1.8 - (elapsed / 60.0)).clamp(0.6, 1.8);

      if (spawnTimer >= spawnInterval) {
        spawnTimer = 0;
        spawnCloud();
      }
      
      int smogCount = children.whereType<CloudComponent>().where((c) => c.isSmog).length;
      co2Level = (smogCount * 5).clamp(0, 100);
      
      updateGameState();

      if (remainingTime <= 0) {
        remainingTime = 0;
        if (onGameEnd != null) onGameEnd!(score);
      }
      
      if (co2Level >= 100) {
         co2Level = 100;
        // Could implement fail state here
      }
    }
  }

  void spawnCloud() {
    // Spawn Logic
    // Start with easy clouds, introduce hard/bonus/penalty as time goes on
    double rand = Random().nextDouble();
    CloudType type;
    
    // Difficulty curve based on remaining time
    double difficultyFactor = (60 - remainingTime) / 60.0; // 0.0 to 1.0

    if (rand < 0.1) {
       type = CloudType.bonus; // 10% Bonus
    } else if (rand < 0.25) {
       type = CloudType.clean; // 15% Clean (Penalty)
    } else {
       // Smog types based on difficulty
       double smogRoll = Random().nextDouble();
       if (difficultyFactor > 0.5 && smogRoll < 0.4) {
         type = CloudType.smogHeavy;
       } else if (difficultyFactor > 0.2 && smogRoll < 0.6) {
         type = CloudType.smogMedium;
       } else {
         type = CloudType.smogLight;
       }
    }

    double x = -50; // Start off-screen left
    double y = Random().nextDouble() * (size.y - 150) + 50;
    
    add(CloudComponent(type: type, startPosition: Vector2(x,y), speedMult: speedMultiplier));
  }

  void handleCloudInteraction(CloudType type, Vector2 position) {
    if (type == CloudType.clean) {
       score -= 10; // Penalty
       // Visual or Audio feedback
    } else if (type == CloudType.bonus) {
       score += 50;
       remainingTime += 5; // Bonus Time!
    } else {
       // Smog cleared
       score += type.score;
    }
    score = max(0, score);
    updateGameState();
  }
  
  void updateGameState() {
    if (onGameStateChanged != null) {
      onGameStateChanged!(co2Level, globalTemp);
    }
  }
}

class CloudComponent extends PositionComponent with TapCallbacks, HasGameReference<ClimateCombatGame> {
  final CloudType type;
  int currentHp;
  final double speedMult;
  double timeAlive = 0;
  
  // Sine wave movement parameters
  final double amplitude;
  final double frequency;
  final double baseSpeed = 40.0;

  CloudComponent({required this.type, required Vector2 startPosition, required this.speedMult}) 
      : currentHp = type.hp,
        amplitude = Random().nextDouble() * 30 + 10,
        frequency = Random().nextDouble() * 2 + 1,
        super(position: startPosition, size: Vector2(70, 50), anchor: Anchor.center);

  bool get isSmog => type == CloudType.smogLight || type == CloudType.smogMedium || type == CloudType.smogHeavy;

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = type.color.withValues(alpha: 0.9);
    
    // Draw cloud shape
    canvas.drawCircle(const Offset(0, 0), 20, paint);
    canvas.drawCircle(const Offset(-15, 5), 15, paint);
    canvas.drawCircle(const Offset(15, 5), 15, paint);
    
    // Visual indicator for HP/Heavy Smog
    if (isSmog && currentHp > 1) {
       final border = Paint()
         ..color = Colors.black.withValues(alpha: 0.5)
         ..style = PaintingStyle.stroke
         ..strokeWidth = 2;
       canvas.drawCircle(const Offset(0, 0), 20, border);
    }
    
    if (type == CloudType.bonus) {
      // Glow or Star
      final starPaint = Paint()..color = Colors.white;
      canvas.drawCircle(const Offset(0,0), 5, starPaint);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (currentHp > 0) {
      currentHp--;
      
      // Visual feedback: Shrink slightly
      scale *= 0.9; 
      
      if (currentHp <= 0) {
        game.handleCloudInteraction(type, position);
        removeFromParent();
      }
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    timeAlive += dt;
    
    // Move Right with Sine Wave
    position.x += (baseSpeed * speedMult) * dt;
    position.y += sin(timeAlive * frequency) * amplitude * dt;

    if (position.x > game.size.x + 50) {
      // Escaped
      removeFromParent();
    }
  }
}
