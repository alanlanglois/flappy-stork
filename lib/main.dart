import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'game/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final screenSize = await Flame.util.initialDimensions();

  var sprite = await Flame.images.loadAll(["sprite.png"]);
  final game = new HikyakuGame(sprite[0], screenSize);

  runApp(game.widget);
}
