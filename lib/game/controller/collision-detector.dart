import 'dart:ui';

import 'package:flame/components/component.dart';

class CollisionDetector {
  static void detectCollision(
      Rect item, List<Rect> obstacles, Function collisionCB) {
    int test = obstacles.length;
    obstacles.forEach((obstacle) {
      if (check2ItemsCollision(item, obstacle)) collisionCB();
    });
  }

  static bool check2ItemsCollision(Rect item1, Rect item2) {
    var intersectedRect = item1.intersect(item2);
    return intersectedRect.width > 5 && intersectedRect.height > 5;
  }
}
