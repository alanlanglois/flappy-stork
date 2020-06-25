import 'dart:collection';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';

import 'config.dart';

class ScoreDigit extends SpriteComponent with Resizable
{
  ScoreDigit(Sprite s)
      : super.fromSprite(ComponentDimensions.numberWidth ,
            ComponentDimensions.numberHeight , s);

}
