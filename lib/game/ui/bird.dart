import 'dart:ui';
import 'dart:developer' as developer;

import 'package:flame/anchor.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';

import 'config.dart';

const double GRAVITY = 400.0;
const double BOOST = -380.0;

class Bird extends AnimationComponent {
  double speedY = 0.0;
  Size _screenSize;
  bool frozen;
  bool isDead = false;
  Position get velocity => Position(300, speedY);

  static List<Sprite> getSprites(Image spriteImage) {
    return [
      Sprite.fromImage(
        spriteImage,
        width: SpriteDimensions.birdWidth,
        height: SpriteDimensions.birdHeight,
        y: SpritesPostions.birdSprite1Y,
        x: SpritesPostions.birdSprite1X,
      ),
      Sprite.fromImage(
        spriteImage,
        width: SpriteDimensions.birdWidth,
        height: SpriteDimensions.birdHeight,
        y: SpritesPostions.birdSprite2Y,
        x: SpritesPostions.birdSprite2X,
      ),
      Sprite.fromImage(
        spriteImage,
        width: SpriteDimensions.birdWidth,
        height: SpriteDimensions.birdHeight,
        y: SpritesPostions.birdSprite3Y,
        x: SpritesPostions.birdSprite3X,
      )
    ];
  }

  Bird(Image spriteImage, Size screenSize)
      : super(ComponentDimensions.birdWidth, ComponentDimensions.birdHeight,
            Animation.spriteList(getSprites(spriteImage), stepTime: 0.15)) {
    _screenSize = screenSize;
    this.anchor = Anchor.center;
    this.x = 10;
    reset();
  }

  reset() {
    this.x = _screenSize.width / 2;
    this.y = _screenSize.height / 2;
    speedY = 0.0;
    frozen = true;
    angle = 0.0;
    isDead = false;
  }

  stop() {
    isDead = true;
  }

  onTap() {
    if (frozen) {
      frozen = false;
      return;
    }
    speedY = (speedY + BOOST).clamp(BOOST, speedY);
  }

  @override
  void update(double t) {
    if (!isDead) {
      if (!frozen) {
        this.y += speedY * t - GRAVITY * t * t / 2;
        this.speedY += GRAVITY * t;
        this.angle = velocity.angle() / 2;
      }
    }
    if (speedY > 0 || isDead) return;

    super.update(t);
  }
}
