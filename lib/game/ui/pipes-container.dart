import 'dart:ui';
import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:hikyaku2/game/ui/config.dart';
import 'package:hikyaku2/game/ui/pipes.dart';

class PipesContainer extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent {
  Image _spriteImage;
  Size _screenSize;
  Function _countPointCB;
  List<Pipes> _pipesList;
  bool isPlaying;
  bool readyToDestroy = false;
  List<Rect> obstacles;
  double halfScreen;

  PipesContainer(Image spriteImage, Size screenSize, Function countPointCB) {
    _spriteImage = spriteImage;
    _screenSize = screenSize;
    _countPointCB = countPointCB;
    _pipesList = List<Pipes>();
    isPlaying = true;
    halfScreen = (screenSize.width - ComponentDimensions.tubeWidth) / 2;
  }

  void createPipes() {
    Pipes pipes = new Pipes(_spriteImage, _screenSize);
    _pipesList.add(pipes);
    this..add(pipes);
    pipes.x = _screenSize.width + 5;
  }

  void deletePipes(Pipes pipes) {
    _pipesList.remove(pipes);
    pipes.destroy();
  }

  @override
  void update(double t) {
    // TODO: implement update
    obstacles = null;
    if (isPlaying) {
      if (_pipesList != null) {
        Pipes pipes;
        obstacles = List<Rect>();
        for (int i = 0; i < _pipesList.length; i++) {
          pipes = _pipesList[i];
          pipes.update(t);
          if (pipes.position.x < -ComponentDimensions.tubeWidth) {
            deletePipes(pipes);
          } else if (pipes.position.x < halfScreen && !pipes.hasBeenCounted) {
            pipes.hasBeenCounted = true;
            _countPointCB();
          } else {
            obstacles.addAll(pipes.getRects());
          }
        }
      }
    }
  }

  void start() {
    reset();
    isPlaying = true;
  }

  void stop() {
    isPlaying = false;
  }

  void reset() {
    if (_pipesList != null) {
      while (_pipesList.length > 0) {
        deletePipes(_pipesList[0]);
      }
    }
  }
}
