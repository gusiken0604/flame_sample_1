import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';

import 'bullet.dart';
import 'joystick_player.dart';

main() {
  final example = CaseStudy002Slide002();
  runApp(
    GameWidget(game: example),
  );
}

class CaseStudy002Slide002 extends FlameGame with HasDraggables, HasTappables {
  static const String description = '''
    In this example we showcase how to use the joystick by creating simple
    `CircleComponent`s that serve as the joystick's knob and background.
    Steer the player by using the joystick. We also show how to shoot bullets
    and how to find the angle of the bullet path relative to the ship's angle
  ''';

  //
  // The player being controlled by Joystick
  late final JoystickPlayer player;
  //
  // The actual Joystick component
  late final JoystickComponent joystick;
  //
  // angle of the ship being displayed on canvas
  final TextPaint shipAngleTextPaint = TextPaint();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //
    // joystick knob and background skin styles
    final knobPaint = BasicPalette.green.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.green.withAlpha(100).paint();
    //
    // Actual Joystick component creation
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 15, paint: knobPaint),
      background: CircleComponent(radius: 50, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );

    //
    // adding the player that will be controlled by our joystick
    player = JoystickPlayer(joystick);

    //
    // add both joystick and the controlled player to the game instance
    add(player);
    add(joystick);
  }

  @override
  void update(double dt) {
    //
    //  show the angle of the player
    print("current player angle: ${player.angle}");
    super.update(dt);
  }

  @override
  //
  //
  // We will handle the tap action by the user to shoot a bullet
  // each time the user taps and lifts their finger
  void onTapUp(int pointerId, TapUpInfo info) {
    //
    // velocity vector pointing straight up.
    // Represents 0 radians which is 0 desgrees
    var velocity = Vector2(0, -1);
    // rotate this vector to the same ange as the player
    velocity.rotate(player.angle);
    // create a bullet with the specific angle and add it to the game
    add(Bullet(player.position, velocity));
    super.onTapUp(pointerId, info);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    //
    // render the angle in radians for reference
    shipAngleTextPaint.render(
      canvas,
      '${player.angle.toStringAsFixed(5)} radians',
      Vector2(20, size.y - 24),
    );
  }
}
