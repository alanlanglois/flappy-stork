import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/nine_tile_box.dart';
import 'package:flame/palette.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:hikyaku2/game/ui/config.dart';

class GameOver extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent {
  Size _screenSize;
  Image _spriteImage;
  NineTileBox tiledBG;
  double horizontalPadding = 30;
  double verticalPadding = 80;
  TextComponent text_l1;
  TextComponent text_l2;
  TextComponent text_l3;
  TextComponent releaseDate;
  TextComponent releaseDate2;
  TextComponent releaseDate3;
  bool isOnAir;
  int lastSpawnTime;
  int lastSpawnID = 0;
  List<PositionComponent> itemList;
  int score = 0;
  int SCORE_MIN = 2;
  List<Position> finalPos;

  GameOver(Image spriteImage, Size screenSize) {
    _screenSize = screenSize;
    _spriteImage = spriteImage;
    itemList = List<PositionComponent>();
    finalPos = List<Position>();

    Sprite sprite = Sprite.fromImage(
      spriteImage,
      width: SpriteDimensions.gameOverWidth,
      height: SpriteDimensions.gameOverHeight,
      y: SpritesPostions.gameOverY,
      x: SpritesPostions.gameOverX,
    );

    tiledBG = NineTileBox(
      sprite,
      tileSize: 6,
      destTileSize: 12,
    );

    if (score > SCORE_MIN) {
      buildBaby();
    } else {
      buildSimpleUI();
    }
  }

  buildSimpleUI() {
    removeElement();
    itemList.clear();
    finalPos.clear();
    TextConfig regular = TextConfig(
        color: BasicPalette.black.color, fontFamily: "PlayMe", fontSize: 40);
    TextConfig smaller = regular.withFontSize(30);
    text_l1 = TextComponent("GAME OVER", config: regular);
    text_l2 = TextComponent("SCORE : $score", config: regular);
    text_l3 = TextComponent("TRY AGAIN", config: regular);
    text_l1.x = (_screenSize.width - text_l1.width) / 2;
    text_l1.y = verticalPadding * 3 + 60;
    text_l2.x = (_screenSize.width - text_l2.width) / 2;
    text_l2.y = text_l1.y + text_l1.height + 5;
    text_l3.x = (_screenSize.width - text_l3.width) / 2;
    text_l3.y = text_l2.y + text_l2.height + 5;
    itemList..add(text_l1)..add(text_l2)..add(text_l3);

    itemList.forEach((element) {
      this.add(element);
      finalPos.add(Position(element.x, element.y));
    });
  }

  buildBaby() {
    removeElement();
    itemList.clear();
    finalPos.clear();
    SpriteComponent baby = SpriteComponent.fromSprite(
        SpriteDimensions.babyWidth,
        SpriteDimensions.babyHeight,
        Sprite.fromImage(_spriteImage,
            width: SpriteDimensions.babyWidth,
            height: SpriteDimensions.babyHeight,
            x: SpritesPostions.babyX,
            y: SpritesPostions.babyY));

    baby.width = _screenSize.width - horizontalPadding * 2 - 40;
    baby.height = ComponentDimensions.babyHeight *
        baby.width /
        ComponentDimensions.babyWidth;
    baby.x = (_screenSize.width - baby.width) / 2;
    baby.y = (_screenSize.height - baby.width) / 2 + 30;

    TextConfig regular = TextConfig(
        color: BasicPalette.black.color, fontFamily: "PlayMe", fontSize: 40);
    TextConfig smaller = regular.withFontSize(30);

    text_l1 = TextComponent("LA PARTIE", config: regular);
    text_l2 = TextComponent("NE FAIT QUE", config: regular);
    text_l3 = TextComponent("COMMENCER", config: regular);

    itemList..add(text_l1)..add(text_l2)..add(text_l3)..add(baby);

    text_l1.x = (_screenSize.width - text_l1.width) / 2;
    text_l1.y = verticalPadding + 40;
    text_l2.x = (_screenSize.width - text_l2.width) / 2;
    text_l2.y = text_l1.y + text_l1.height + 5;
    text_l3.x = (_screenSize.width - text_l3.width) / 2;
    text_l3.y = text_l2.y + text_l2.height + 5;
    releaseDate = TextComponent("NOUVEAU JOUEUR", config: smaller);
    releaseDate2 = TextComponent("PREVU POUR", config: smaller);
    releaseDate3 = TextComponent("DECEMBRE 2020", config: smaller);

    releaseDate.x = (_screenSize.width - releaseDate.width) / 2;
    releaseDate.y = baby.y + baby.height + 50;
    releaseDate2.x = (_screenSize.width - releaseDate2.width) / 2;
    releaseDate2.y = releaseDate.y + releaseDate.height + 5;
    releaseDate3.x = (_screenSize.width - releaseDate3.width) / 2;
    releaseDate3.y = releaseDate2.y + releaseDate2.height + 5;

    itemList..add(releaseDate)..add(releaseDate2)..add(releaseDate3);

    itemList.forEach((element) {
      this.add(element);
      finalPos.add(Position(element.x, element.y));
    });
  }

  void removeElement() {
    itemList.forEach((element) {
      element.x = 10000;
    });
  }

  @override
  void render(Canvas canvas) {
    if (score > SCORE_MIN) {
      tiledBG.draw(
          canvas,
          horizontalPadding,
          verticalPadding,
          _screenSize.width - horizontalPadding * 2,
          _screenSize.height - verticalPadding * 2);
    } else {
      tiledBG.draw(
          canvas,
          horizontalPadding,
          verticalPadding * 3,
          _screenSize.width - horizontalPadding * 2,
          _screenSize.height - verticalPadding * 6);
    }

    // TODO: implement render
    super.render(canvas);
  }

  void onAir() {
    isOnAir = true;
    lastSpawnTime = DateTime.now().millisecondsSinceEpoch - 250;
    removeElement();
    lastSpawnID = 0;
  }

  updateScore(int value) {
    score = value;
    if (score > SCORE_MIN) {
      buildBaby();
    } else {
      buildSimpleUI();
    }
  }

  @override
  void update(double t) {
    // TODO: implement update
    if (isOnAir) {
      if (score <= SCORE_MIN) text_l2.text = "SCORE : $score";
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      if (currentTime > lastSpawnTime + 800) {
        lastSpawnTime = currentTime;
        if (lastSpawnID < itemList.length) {
          itemList[lastSpawnID].x = finalPos[lastSpawnID].x;
          lastSpawnID++;
        }
      }
    }
    super.update(t);
  }

  @override
  bool destroy() {
    // TODO: implement destroy
    print("DESTS");
    return true;
  }
}
