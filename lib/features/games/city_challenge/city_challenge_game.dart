import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class CityChallengeGame extends FlameGame with HasCollisionDetection, PanDetector {
  final Function(int score, int timeLeft)? onGameStateChanged;
  final Function(int score)? onGameEnd;

  late BinComponent bin;
  int score = 0;
  double remainingTime = 60.0;
  double trashSpawnTimer = 0.0;
  
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
    
    // Initial State Update
    if (onGameStateChanged != null) {
      onGameStateChanged!(score, remainingTime.ceil());
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (remainingTime > 0) {
      remainingTime -= dt;
      
      // Spawn Trash
      trashSpawnTimer += dt;
      if (trashSpawnTimer > 1.0) { // Spawn every second
        trashSpawnTimer = 0;
        spawnTrash();
      }

      if (onGameStateChanged != null) {
        onGameStateChanged!(score, remainingTime.ceil());
      }
      if (remainingTime <= 0) {
        remainingTime = 0;
        if (onGameEnd != null) onGameEnd!(score);
      }
    }
  }

  void spawnTrash() {
    final trashType = Random().nextBool() ? 'trash_bottle.png' : 'trash_can.png';
    add(TrashItem(trashType, Vector2(Random().nextDouble() * (size.x - 50) + 25, -50)));
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // Move bin with drag
    bin.position.x += info.delta.global.x;
    // Clamp to screen
    bin.position.x = bin.position.x.clamp(bin.size.x / 2, size.x - bin.size.x / 2);
  }

  void catchTrash() {
    score += 10;
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
  final String spriteName;
  final double speed = 200;

  TrashItem(this.spriteName, Vector2 pos) : super(position: pos, size: Vector2(40, 60), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(spriteName);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;

    if (position.y > game.size.y + 100) {
      removeFromParent(); // Missed
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BinComponent) {
      game.catchTrash();
      removeFromParent();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
