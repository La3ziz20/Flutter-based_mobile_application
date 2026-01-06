import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

enum WaterItemType {
  trash(score: 10, color: Colors.brown),
  oil(score: 20, color: Colors.black),
  wildlife(score: -50, color: Colors.pinkAccent); // Penalty if touched with wrong tool or at all? Let's say avoid.

  final int score;
  final Color color;
  const WaterItemType({required this.score, required this.color});
}

class WaterCleanupGame extends FlameGame with TapCallbacks, PanDetector {
  final Function(int score, int timeLeft)? onGameStateChanged;
  final Function(int score)? onGameEnd;

  late BoatComponent boat;
  int score = 0;
  double remainingTime = 60.0;
  double spawnTimer = 0.0;
  double currentSpeed = 50.0; // Current speed

  WaterCleanupGame({this.onGameStateChanged, this.onGameEnd});

  @override
  Future<void> onLoad() async {
    // Water Background
    Sprite bgSprite;
    try {
      bgSprite = await loadSprite('ocean_bg.png');
    } catch(e) {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final r = Offset.zero & size.toSize();
      final g = LinearGradient(colors: [Colors.blue[300]!, Colors.blue[900]!], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(r);
      canvas.drawRect(r, Paint()..shader = g);
      final picture = recorder.endRecording();
      final image = await picture.toImage(size.x.toInt(), size.y.toInt());
      bgSprite = Sprite(image);
    }

    add(SpriteComponent(
      sprite: bgSprite,
      size: size,
    ));

    // Current lines (Visual)
    for(int i=0; i<5; i++) {
      add(CurrentEffect(Vector2(0, size.y/5 * i + 30), size.x));
    }

    boat = BoatComponent()..position = size / 2;
    add(boat);

    updateGameState();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (remainingTime > 0) {
      remainingTime -= dt;
      spawnTimer += dt;
      
      if (spawnTimer >= 1.5) {
        spawnTimer = 0;
        spawnItem();
      }

      updateGameState();

      if (remainingTime <= 0) {
        remainingTime = 0;
        if (onGameEnd != null) onGameEnd!(score);
      }
    }
  }

  void spawnItem() {
    double rand = Random().nextDouble();
    WaterItemType type;
    if (rand < 0.1) type = WaterItemType.wildlife; // 10% Wildlife
    else if (rand < 0.4) type = WaterItemType.oil; // 30% Oil
    else type = WaterItemType.trash; // 60% Trash

    // Spawn from LEFT side moving RIGHT with current
    double y = Random().nextDouble() * (size.y - 50) + 25;
    add(FloatingItem(type: type, startPos: Vector2(-30, y)));
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    boat.position += info.delta.global;
    boat.position.clamp(Vector2.zero(), size); // Keep in bounds
  }

  void handleCollection(WaterItemType type) {
    if (type == WaterItemType.wildlife) {
      score += type.score; // Penalty
      // Maybe game over?
    } else {
      score += type.score;
    }
    score = max(0, score);
    updateGameState();
  }

  void updateGameState() {
    if (onGameStateChanged != null) {
      onGameStateChanged!(score, remainingTime.ceil());
    }
  }
}

class CurrentEffect extends PositionComponent {
   final double width;
   CurrentEffect(Vector2 pos, this.width) : super(position: pos);
   
   @override
   void render(Canvas canvas) {
     final paint = Paint()
       ..color = Colors.white.withValues(alpha: 0.2)
       ..style = PaintingStyle.stroke
       ..strokeWidth = 2;
     // simple dashed line
     double dashWidth = 10, dashSpace = 10, startX = 0;
     while (startX < width) {
        canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
        startX += dashWidth + dashSpace;
     }
   }
}

class BoatComponent extends SpriteComponent with HasGameReference<WaterCleanupGame> {
  BoatComponent() : super(size: Vector2(50, 50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
     try {
       sprite = await game.loadSprite('cleanup_boat.png');
     } catch(e) {
       // Boat Fallback (Triangle)
       final recorder = PictureRecorder();
       final canvas = Canvas(recorder);
       final paint = Paint()..color = Colors.orange;
       final path = Path()..moveTo(0, 25)..lineTo(40, 0)..lineTo(40, 50)..close();
       canvas.drawPath(path, paint);
       final picture = recorder.endRecording();
       final image = await picture.toImage(50, 50);
       sprite = Sprite(image);
     }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Check collisions
    game.children.whereType<FloatingItem>().forEach((item) {
      if (position.distanceTo(item.position) < (size.x/2 + item.size.x/2)) {
        game.handleCollection(item.type);
        item.removeFromParent();
      }
    });
  }
}

class FloatingItem extends SpriteComponent with HasGameReference<WaterCleanupGame> {
  final WaterItemType type;
  final double speed;
  
  FloatingItem({required this.type, required Vector2 startPos}) 
      : speed = Random().nextDouble() * 50 + 50, 
        super(position: startPos, size: Vector2(40, 40), anchor: Anchor.center);

  Future<Sprite> _loadSpriteWithFallback(String assetName, Color fallbackColor) async {
    try {
      return await game.loadSprite(assetName);
    } catch (e) {
      debugPrint("Asset not found: $assetName. Using fallback.");
      return _createFallbackSprite(fallbackColor);
    }
  }

  Future<Sprite> _createFallbackSprite(Color color) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = color;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 40, 40), paint);
    
    // Add simple icon/symbol?
    final p2 = Paint()..color = Colors.white..style=PaintingStyle.stroke..strokeWidth=2;
    canvas.drawCircle(const Offset(20,20), 10, p2);

    final picture = recorder.endRecording();
    final image = await picture.toImage(40, 40);
    return Sprite(image);
  }

  @override
  Future<void> onLoad() async {
     String assetName = '';
     Color fallbackColor = Colors.red;
     
     switch (type) {
       case WaterItemType.trash:
         assetName = 'ocean_trash.png';
         fallbackColor = Colors.grey;
         break;
       case WaterItemType.oil:
         assetName = 'ocean_oil.png'; 
         fallbackColor = Colors.black;
         break;
       case WaterItemType.wildlife:
         assetName = 'ocean_wildlife.png'; 
         fallbackColor = Colors.orange;
         break;
     }
     
     sprite = await _loadSpriteWithFallback(assetName, fallbackColor);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move with current (Right)
    position.x += speed * dt;

    // Bobbing effect
    position.y += sin(game.remainingTime * 2) * 0.5;

    if (position.x > game.size.x + 50) {
      removeFromParent();
    }
  }
}
