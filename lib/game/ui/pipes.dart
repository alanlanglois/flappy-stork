import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';

import 'config.dart';

class Pipes extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent {
  Size _screenSize;
  SpriteComponent topPipe;
  SpriteComponent bottomPipe;
  int gateSize = 280;
  int tubePadding = 15;
  double offsetPipes;
  Position position;
  bool hasBeenCounted = false;

  Pipes(
    Image spriteImage,
    Size screenSize,
  ) {
    _screenSize = screenSize;
    offsetPipes = _screenSize.height * 0.3;
    position = Position(0, 0);
    buildUI(
        Sprite.fromImage(
          spriteImage,
          width: SpriteDimensions.tubeWidth,
          height: SpriteDimensions.tubeHeight,
          y: SpritesPostions.tubeTopY,
          x: SpritesPostions.tubeTopX,
        ),
        Sprite.fromImage(
          spriteImage,
          width: SpriteDimensions.tubeWidth,
          height: SpriteDimensions.tubeHeight,
          y: SpritesPostions.tubeBottomY,
          x: SpritesPostions.tubeBottomX,
        ));
  }

  void buildUI(Sprite topSprite, Sprite bottomSprite) {
    topPipe = SpriteComponent.fromSprite(ComponentDimensions.tubeWidth,
        ComponentDimensions.tubeHeight, topSprite);
    bottomPipe = SpriteComponent.fromSprite(ComponentDimensions.tubeWidth,
        ComponentDimensions.tubeHeight, bottomSprite);
    this..add(topPipe)..add(bottomPipe);
    setPositions();
  }

  void setPositions() {
    position.x = _screenSize.width + 10;
    topPipe.x = bottomPipe.x = position.x;

    double middle = (topPipe.height + bottomPipe.height + gateSize) / 2;
    topPipe.y = -middle +
        _screenSize.height / 2 +
        (Random().nextDouble() * offsetPipes - offsetPipes / 2);
    bottomPipe.y = topPipe.y + topPipe.height + gateSize;
  }

  List<Rect> getRects() {
    return [topPipe.toRect(), bottomPipe.toRect()];
  }

  @override
  void update(double t) {
    // TODO: implement update
    position.x -= t * Speed.GroundSpeed;
    topPipe.x = bottomPipe.x = position.x;
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    if (topPipe != null && bottomPipe != null) super.render(canvas);
  }

  @override
  bool destroy() {
    // TODO: implement destroy
    topPipe.destroy();
    bottomPipe.destroy();
    topPipe = null;
    bottomPipe = null;
    super.destroy();
  }
}
