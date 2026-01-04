import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class EcoHeroGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late PlayerComponent player;
  final Function(int score, int timeLeft)? onGameStateChanged;
  final Function(int score)? onGameEnd;
  
  int score = 0;
  double remainingTime = 60.0;

  EcoHeroGame({this.onGameStateChanged, this.onGameEnd});
  
  @override
  Future<void> onLoad() async {
    // Background
    add(SpriteComponent(
      sprite: await loadSprite('eco_hero_bg.png'),
      size: size,
    ));

    // Add player
    player = PlayerComponent()
      ..position = size / 2;
    add(player);

    // Spawn initial trash items
    add(TrashComponent(Vector2(100, 100)));
    add(TrashComponent(Vector2(size.x - 100, 200)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (remainingTime > 0) {
      remainingTime -= dt;
      if (onGameStateChanged != null) {
        onGameStateChanged!(score, remainingTime.ceil());
      }
      if (remainingTime <= 0) {
        remainingTime = 0;
        if (onGameEnd != null) onGameEnd!(score);
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Move player to tap position
    player.setTarget(event.localPosition);
  }
  
  void increaseScore() {
    score += 10;
     // Trigger update immediately on score change
     if (onGameStateChanged != null) {
        onGameStateChanged!(score, remainingTime.ceil());
      }
  }
}

class PlayerComponent extends SpriteComponent with HasGameReference<EcoHeroGame> {
  Vector2? targetPosition;
  final double speed = 200;

  PlayerComponent() : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('eco_hero_player.png');
    anchor = Anchor.center;
  }

  void setTarget(Vector2 target) {
    targetPosition = target;
    // Simple flip for direction
    if (target.x < position.x) {
      scale = Vector2(-1, 1);
    } else {
      scale = Vector2(1, 1);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (targetPosition != null) {
      final direction = (targetPosition! - position).normalized();
      final distance = (targetPosition! - position).length;
      
      if (distance < 5) {
        targetPosition = null; // Reached target
      } else {
        position += direction * speed * dt;
      }
    }
    
    // Check collisions with Trash
    game.children.whereType<TrashComponent>().forEach((trash) {
      if (position.distanceTo(trash.position) < 40) {
        trash.collect();
        game.increaseScore();
      }
    });
  }
}

class TrashComponent extends SpriteComponent with HasGameReference<EcoHeroGame> {
  TrashComponent(Vector2 pos) : super(position: pos, size: Vector2(40, 40));

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('trash.png');
    anchor = Anchor.center;
  }
  
  void collect() {
    removeFromParent();
    // Respawn somewhere else/randomly
    game.add(TrashComponent(
      Vector2(
        Random().nextDouble() * (game.size.x - 50), 
        Random().nextDouble() * (game.size.y - 50)
      )
    ));
  }
}
