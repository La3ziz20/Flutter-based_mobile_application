import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class ClimateCombatGame extends FlameGame {
  // Keeping these labels for constructor compatibility, though unused in new logic
  final String plantTreesLabel;
  final String industrialGrowthLabel;
  
  final Function(int co2, int temp)? onGameStateChanged;
  final Function(int score)? onGameEnd;

  int score = 0;
  // CO2 simulates the number of active clouds or "pollution level"
  int co2Level = 0; 
  int globalTemp = 15; // Decoration/Flavor
  double remainingTime = 60.0;
  double spawnTimer = 0.0;
  double spawnInterval = 1.5;

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

      // Spawn Smog Clouds
      if (spawnTimer >= spawnInterval) {
        spawnTimer = 0;
        spawnSmog();
        // Increase difficulty by spawning faster over time
        spawnInterval = (spawnInterval * 0.98).clamp(0.5, 2.0);
      }
      
      // Update CO2 level based on active smog clouds
      int cloudCount = children.whereType<SmogCloud>().length;
      co2Level = cloudCount * 5; // Arbitrary scale
      
      updateGameState();

      if (remainingTime <= 0) {
        remainingTime = 0;
        if (onGameEnd != null) onGameEnd!(score);
      }
      
      // Fail condition: Too much pollution (optional)
      if (co2Level >= 100) {
         // Force game over ? Or just cap it? Let's just cap for now to be friendly.
         co2Level = 100;
      }
    }
  }

  void spawnSmog() {
    double x = Random().nextDouble() * (size.x - 60) + 30;
    double y = Random().nextDouble() * (size.y - 150) + 50;
    add(SmogCloud(position: Vector2(x,y)));
  }

  void onSmogDestroyed() {
    score += 10;
    // Clearing smog lowers localized temp slightly or just flavor
    updateGameState();
  }
  
  void updateGameState() {
    if (onGameStateChanged != null) {
      onGameStateChanged!(co2Level, globalTemp);
    }
  }
}

class SmogCloud extends PositionComponent with TapCallbacks, HasGameReference<ClimateCombatGame> {
  SmogCloud({required Vector2 position}) : super(position: position, size: Vector2(60, 40), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Drawing a simple cloud shape using a composition of circles since we don't have the asset
    // Or just a Rect component with rounded corners.
  }
  
  @override
  void render(Canvas canvas) {
    // Draw a "cloud" look using Paint
    final paint = Paint()..color = Colors.grey.withValues(alpha: 0.8);
    // 3 overlapping circles
    canvas.drawCircle(const Offset(0, 0), 20, paint);
    canvas.drawCircle(const Offset(-15, 5), 15, paint);
    canvas.drawCircle(const Offset(15, 5), 15, paint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.onSmogDestroyed();
    removeFromParent();
    // Could add a particle effect here "Poof"
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    // Float slowly to the right
    position.x += 10 * dt;
    if (position.x > game.size.x + 50) {
      // Wrap around or disappear? Let's disappear and count as "pollution escaped" (bad)
      // For now just remove to keep performance
      removeFromParent();
    }
  }
}
