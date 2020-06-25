import 'dart:collection';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:hikyaku2/game/ui/score-digit.dart';

import 'config.dart';

class Score extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent {
  HashMap _digits;
  List<ScoreDigit> digitList;
  int digitGap = 3;
  int currentScore = 0;
  Size _screenSize;

  Score(Image spriteImage, Size screenSize) {
    _screenSize = screenSize;
    _initSprites(spriteImage);
    this.setByPosition(Position(_screenSize.width / 2, 80));

    digitList = List<ScoreDigit>();
    addDigit();
    updateScore(0);
    setDigitsPosition();
  }

  void updateScore(int score) {
    print("score $score");
    if (score > currentScore) {
      if (score < 0) score = 0;
      int valueLength = score.toString().length;
      while (digitList.length < valueLength) {
        addDigit();
      }
      ScoreDigit digit;
      for (int i = 0; i < digitList.length; i++) {
        digit = digitList[i];
        print(valueLength - (i + 1));
        digit.sprite = _digits[score.toString()[valueLength - (i + 1)]];
      }
      setDigitsPosition();
    }
  }

  void addDigit([int value = 0]) {
    print("ADD DIGIT $value");
    if (value > 9) value = 9;
    ScoreDigit digit = new ScoreDigit(_digits[value.toString()]);
    digitList.add(digit);
    this..add(digit);
  }

  void _initSprites(Image spriteImage) {
    _digits = HashMap.from({
      "0": Sprite.fromImage(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.zeroNumberX,
        y: SpritesPostions.zeroNumberY,
      ),
      "1": Sprite.fromImage(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.firstNumberX,
        y: SpritesPostions.firstNumberY,
      ),
      "2": Sprite.fromImage(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.secondNumberX,
        y: SpritesPostions.secondNumberY,
      ),
      "3": Sprite.fromImage(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.thirdNumberX,
        y: SpritesPostions.thirdNumberY,
      ),
      "4": Sprite.fromImage(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.fourthNumberX,
        y: SpritesPostions.fourthNumberY,
      ),
      "5": Sprite.fromImage(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.fifthNumberX,
        y: SpritesPostions.fifthNumberY,
      ),
      "6": Sprite.fromImage(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.sixthNumberX,
        y: SpritesPostions.sixthNumberY,
      ),
      "7": Sprite.fromImage(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.seventhNumberX,
        y: SpritesPostions.seventhNumberY,
      ),
      "8": Sprite.fromImage(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.eighthNumberX,
        y: SpritesPostions.eighthNumberY,
      ),
      "9": Sprite.fromImage(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.ninethNumberX,
        y: SpritesPostions.ninethNumberY,
      )
    });
  }

  void setDigitsPosition() {
    int nbDigit = digitList.length;
    double totalWidth =
        ComponentDimensions.numberWidth * nbDigit + digitGap * (nbDigit - 1);
    ScoreDigit digit;
    double offsetX = (_screenSize.width - totalWidth) / 2;

    for (int i = 0; i < nbDigit; i++) {
      digit = digitList[i];
      double relativePosX = (totalWidth -
          ((i + 1) * ComponentDimensions.numberWidth) -
          (i) * digitGap);
      digit.y = 80;
      digit.x = relativePosX + offsetX;
    }
  }

  void reset() {
    while (digitList.length > 0) {
      digitList[0].destroy();
      digitList[0].sprite = null;
      digitList.removeAt(0);
    }

    currentScore = 0;
    digitList = List<ScoreDigit>();
    addDigit();
    updateScore(currentScore);
    setDigitsPosition();
  }
}
