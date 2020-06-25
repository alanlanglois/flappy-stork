import 'dart:ui';

import 'package:flame/components/component.dart';

const int SPAWN_INTERVAL = 2500;

class PipeGenerator extends Component {
  Function _createPipe;
  bool isPlaying = false;
  int nextSpawnTime;

  PipeGenerator(Function createPipe) {
    _createPipe = createPipe;
  }

  void start() {
    isPlaying = true;
    nextSpawnTime = DateTime.now().millisecondsSinceEpoch + SPAWN_INTERVAL;
  }

  void stop() {
    isPlaying = false;
  }

  @override
  void render(Canvas c) {
    // TODO: implement render
  }

  @override
  void update(double t) {
    if (isPlaying) {
      int currentTime = DateTime.now().millisecondsSinceEpoch;

      if (currentTime >= nextSpawnTime) {
        nextSpawnTime = currentTime + SPAWN_INTERVAL;
        _createPipe();
      }
    }
    // TODO: implement update
  }
}
