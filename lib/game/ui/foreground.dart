import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';

import 'config.dart';

class Foreground extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent {
  Size _screneSize;
  Sprite sprite;
  SpriteComponent fg1;
  SpriteComponent fg2;
  Rect _rect;
  Rect get rect => _rect;
  bool isPlaying;

  Foreground(Image spriteImage, Size screenSize) {
    _screneSize = screenSize;
    sprite = Sprite.fromImage(
      spriteImage,
      width: SpriteDimensions.bottomWidth,
      height: SpriteDimensions.bottomHeight,
      y: SpritesPostions.bottomY,
      x: SpritesPostions.bottomX,
    );
    buildForeground();
    setPosition(0.0, _screneSize.height - SpriteDimensions.bottomHeight);
    start();
  }

  void buildForeground() {
    fg1 = SpriteComponent.fromSprite(
        _screneSize.width, ComponentDimensions.bottomHeight, sprite);
    fg2 = SpriteComponent.fromSprite(
        _screneSize.width, ComponentDimensions.bottomHeight, sprite);
    this..add(fg1)..add(fg2);
  }

  void setPosition(double x, double y) {
    if (fg1 == null) return;
    fg1.x = x;
    fg1.y = y;
    fg2.x = fg1.width;
    fg2.y = y;
    _rect = Rect.fromLTWH(
        x, y, _screneSize.width, ComponentDimensions.bottomHeight);
  }

  @override
  void update(double t) {
    if (isPlaying) {
      fg1.x -= t * Speed.GroundSpeed;
      fg2.x -= t * Speed.GroundSpeed;

      if (fg1.x + fg1.width <= 0) {
        fg1.x = fg2.x + fg2.width;
      }

      if (fg2.x + fg2.width <= 0) {
        fg2.x = fg1.x + fg1.width;
      }
    }
  }

  void start() {
    isPlaying = true;
  }

  void stop() {
    isPlaying = false;
  }
}
