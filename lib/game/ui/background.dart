import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/sprite.dart';

import 'config.dart';

class Background extends SpriteComponent with Resizable {
  Background(Image spriteImage, Size screenSize)
      : super.fromSprite(
            screenSize.width,
            screenSize.height,
            Sprite.fromImage(
              spriteImage,
              width: SpriteDimensions.horizontWidth,
              height: SpriteDimensions.horizontHeight,
              y: 0.0,
              x: 0.0,
            )) {}


  @override
  void update(double t) {
    // TODO: implement update
  }
}
