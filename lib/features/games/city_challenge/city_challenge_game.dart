import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

import 'dart:math';

enum TrashType {
  bottle(asset: 'trash_bottle.png', score: 10, isHazard: false),
  can(asset: 'trash_can.png', score: 15, isHazard: false),
  hazard(asset: 'trash_can.png', score: -20, isHazard: true); // Reusing asset with tint for hazard

  final String asset;
  final int score;
  final bool isHazard;
  const TrashType({required this.asset, required this.score, required this.isHazard});
}

class CityChallengeGame extends FlameGame with HasCollisionDetection, PanDetector, HasGameRef {
  final Function(int score, int timeLeft)? onGameStateChanged;
  final Function(int score)? onGameEnd;

  late BinComponent bin;
  late TextComponent comboText;
  
  int score = 0;
  double remainingTime = 60.0;
  double trashSpawnTimer = 0.0;
  double currentSpawnInterval = 1.2;
  double speedMultiplier = 1.0;
  
  int comboCount = 0;
  double comboMultiplier = 1.0;
  
  CityChallengeGame({this.onGameStateChanged, this.onGameEnd});

  @override
  Future<void> onLoad() async {
    // Background
    add(SpriteComponent(
      sprite: await loadSprite('city_challenge_bg.png'),
      size: size,
    ));

    // Player Bin
    bin = BinComponent()..position = Vector2(size.x / 2, size.y - 100);
    add(bin);
    
    // Combo Text
    comboText = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
      ),
      position: Vector2(20, 60),
    );
    add(comboText);
    
    // Initial State Update
    updateGameState();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (remainingTime > 0) {
      remainingTime -= dt;
      
      // Difficulty Scaling
      // Increase speed and Spawn Rate over time
      // Max difficulty at ~30s remaining (30s elapsed)
      double elapsed = 60 - remainingTime;
      speedMultiplier = 1.0 + (elapsed / 60.0) * 1.5; // Up to 2.5x speed
      currentSpawnInterval = (1.2 - (elapsed / 60.0) * 0.7).clamp(0.4, 1.2); 

      // Spawn Trash
      trashSpawnTimer += dt;
      if (trashSpawnTimer > currentSpawnInterval) {
        trashSpawnTimer = 0;
        spawnTrash();
      }

      updateGameState();

      if (remainingTime <= 0) {
        remainingTime = 0;
        if (onGameEnd != null) onGameEnd!(score);
      }
    }
  }

  void spawnTrash() {
    final rand = Random().nextDouble();
    TrashType type;
    
    // 20% chance for hazard
    if (rand < 0.2) {
      type = TrashType.hazard;
    } else if (rand < 0.6) {
      type = TrashType.bottle;
    } else {
      type = TrashType.can;
    }

    double xPos = Random().nextDouble() * (size.x - 50) + 25;
    add(TrashItem(type, Vector2(xPos, -50), speedMultiplier));
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (remainingTime <= 0) return;
    bin.position.x += info.delta.global.x;
    bin.position.x = bin.position.x.clamp(bin.size.x / 2, size.x - bin.size.x / 2);
  }

  void handleCatch(TrashType type) {
    if (type.isHazard) {
      // Hazard Penalty
      score += type.score; // Subtracts points
      resetCombo();
      // Visual feedback for hit? (Shake or Flash - omitted for brevity)
    } else {
      // Valid Catch
      incrementCombo();
      score += (type.score * comboMultiplier).toInt();
    }
    score = max(0, score); // Prevent negative score
    updateGameState();
  }

  void handleMiss() {
    // Missing a non-hazard item breaks combo
    resetCombo();
  }

  void incrementCombo() {
    comboCount++;
    if (comboCount > 2) comboMultiplier = 1.5;
    if (comboCount > 5) comboMultiplier = 2.0;
    if (comboCount > 10) comboMultiplier = 3.0;
    
    updateComboDisplay();
  }

  void resetCombo() {
    if (comboCount > 0) {
       comboCount = 0;
       comboMultiplier = 1.0;
       updateComboDisplay();
    }
  }
  
  void updateComboDisplay() {
    if (comboCount > 1) {
      comboText.text = 'Combo x$comboCount\nMultiplier x${comboMultiplier.toStringAsFixed(1)}';
      comboText.textRenderer = TextPaint(
        style: TextStyle(
          fontSize: 24, 
          fontWeight: FontWeight.bold, 
          color: comboMultiplier >= 3.0 ? Colors.red : (comboMultiplier >= 2.0 ? Colors.orange : Colors.yellow),
          shadows: [const Shadow(blurRadius: 2, color: Colors.black, offset: Offset(1,1))]
        ),
      );
    } else {
      comboText.text = '';
    }
  }

  void updateGameState() {
     if (onGameStateChanged != null) {
        onGameStateChanged!(score, remainingTime.ceil());
     }
  }
}

class BinComponent extends SpriteComponent with HasGameReference<CityChallengeGame>, CollisionCallbacks {
  BinComponent() : super(size: Vector2(80, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('recycling_bin.png');
    add(RectangleHitbox());
  }
}

class TrashItem extends SpriteComponent with HasGameReference<CityChallengeGame>, CollisionCallbacks {
  final TrashType type;
  final double baseSpeed = 200;
  final double variableSpeed;

  TrashItem(this.type, Vector2 pos, double speedMult) 
      : variableSpeed = speedMult, 
        super(position: pos, size: Vector2(40, 60), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(type.asset);
    if (type.isHazard) {
      // Tint hazards red
      paint.colorFilter = const ColorFilter.mode(Colors.red, BlendMode.srcATop);
    }
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += (baseSpeed * variableSpeed) * dt;

    if (position.y > game.size.y + 100) {
      if (!type.isHazard) {
         game.handleMiss();
      }
      removeFromParent(); 
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BinComponent) {
      game.handleCatch(type);
      removeFromParent();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
