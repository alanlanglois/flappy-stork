import 'dart:ui';
import 'package:flame/game.dart';
import 'package:hikyaku2/game/controller/collision-detector.dart';
import 'package:hikyaku2/game/controller/pipe-generator.dart';
import 'package:hikyaku2/game/ui/background.dart';
import 'package:hikyaku2/game/ui/bird.dart';
import 'package:hikyaku2/game/ui/config.dart';

import 'package:hikyaku2/game/ui/foreground.dart';
import 'package:hikyaku2/game/ui/pipes-container.dart';
import 'package:hikyaku2/game/ui/score.dart';
import 'package:hikyaku2/game/views/game-over.dart';

class HikyakuGame extends BaseGame {
  Size _screenSize;
  PipeGenerator pipeGenerator;

  Bird bird;
  Foreground foreground;
  PipesContainer pipeContainer;
  GameOver gameOverView;
  Score score;
  bool isPlaying = false;
  bool pauseUI = false;
  int point = 0;
  bool displayGameOver = false;

  HikyakuGame(Image spriteImage, Size screenSize) {
    //todo
    _screenSize = screenSize;

    bird = Bird(spriteImage, _screenSize);

    pipeGenerator = PipeGenerator(createPipes);
    pipeContainer = PipesContainer(spriteImage, screenSize, countPoint);
    foreground = Foreground(spriteImage, screenSize);
    score = Score(spriteImage, screenSize);
    gameOverView = GameOver(spriteImage, screenSize);

    add(Background(spriteImage, _screenSize));
    add(pipeContainer);
    add(bird);
    add(foreground);
    add(score);

    score.x = _screenSize.width / 2;
    score.y = 50;
  }

  createPipes() {
    pipeContainer.createPipes();
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    super.render(canvas);
    if (displayGameOver) gameOverView.render(canvas);
  }

  @override
  void update(double t) {
    // TODO: implement update
    if (bird.y > _screenSize.height - ComponentDimensions.bottomHeight + 15) {
      collisionHandler();
    }
    if (!pauseUI) {
      pipeGenerator.update(t);
      if (pipeContainer.obstacles != null) {
        CollisionDetector.detectCollision(
            bird.toRect(), pipeContainer.obstacles, collisionHandler);
      }
    }
    if (displayGameOver) gameOverView.update(t);
    super.update(t);
  }

  countPoint() {
    point++;
    score.updateScore(point);
    gameOverView.updateScore(point);
    score.x = _screenSize.width / 2;
    score.y = 50;
  }

  void collisionHandler() {
    pauseUI = true;
    //gameOver
    bird.stop();
    foreground.stop();
    pipeContainer.stop();
    isPlaying = false;
    displayGameOver = true;
    gameOverView.onAir();
  }

  @override
  void onTap(int pointerId) {
    // TODO: implement onTap
    bird.onTap();

    if (!isPlaying && bird.isDead == false) {
      isPlaying = true;
      pipeGenerator.start();
    } else if (!isPlaying && bird.isDead) {
      point = 0;
      bird.reset();
      foreground.start();
      pipeContainer.start();
      score.reset();
      gameOverView.updateScore(0);
      pauseUI = false;
      displayGameOver = false;
    }
  }
}
