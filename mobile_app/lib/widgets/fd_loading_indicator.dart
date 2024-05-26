import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../style/colors.dart';

class FDLoadingIndicator extends StatefulWidget {
  final Color? color;
  const FDLoadingIndicator({
    Key? key,
    required this.radius,
    required this.dotRadius,
    this.color,
  }) : super(key: key);
  final double radius;
  final double dotRadius;

  @override
  State<FDLoadingIndicator> createState() => _FDLoadingIndicatorState();
}

class _FDLoadingIndicatorState extends State<FDLoadingIndicator> {
  double turns = 0.0;
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 250),
        (_) => setState(() => turns += 1.0 / 8.0));
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double radius = widget.radius;
    final double dotRadius = widget.dotRadius;

    final Color primaryColor = widget.color ?? BVColors.gold;
    return SizedBox(
      height: radius * 2.5,
      width: radius * 2.5,
      child: Center(
        child: AnimatedRotation(
          turns: turns,
          duration: const Duration(milliseconds: 250),
          child: Stack(
            children: [
              Transform.translate(
                offset: Offset(
                  radius * cos(pi / 4),
                  radius * sin(pi / 4),
                ),
                child: Dot(
                  radius: dotRadius,
                  color: primaryColor.withOpacity(0.1),
                ),
              ),
              Transform.translate(
                offset: Offset(
                  radius * cos(2 * pi / 4),
                  radius * sin(2 * pi / 4),
                ),
                child: Dot(
                  radius: dotRadius,
                  color: primaryColor.withOpacity(0.25),
                ),
              ),
              Transform.translate(
                offset: Offset(
                  radius * cos(3 * pi / 4),
                  radius * sin(3 * pi / 4),
                ),
                child: Dot(
                  radius: dotRadius,
                  color: primaryColor.withOpacity(0.4),
                ),
              ),
              Transform.translate(
                offset: Offset(
                  radius * cos(4 * pi / 4),
                  radius * sin(4 * pi / 4),
                ),
                child: Dot(
                  radius: dotRadius,
                  color: primaryColor.withOpacity(0.55),
                ),
              ),
              Transform.translate(
                offset:
                    Offset(radius * cos(5 * pi / 4), radius * sin(5 * pi / 4)),
                child: Dot(
                  radius: dotRadius,
                  color: primaryColor.withOpacity(0.7),
                ),
              ),
              Transform.translate(
                offset: Offset(
                  radius * cos(6 * pi / 4),
                  radius * sin(6 * pi / 4),
                ),
                child: Dot(
                  radius: dotRadius,
                  color: primaryColor.withOpacity(0.85),
                ),
              ),
              Transform.translate(
                offset:
                    Offset(radius * cos(7 * pi / 4), radius * sin(7 * pi / 4)),
                child: Dot(
                  radius: dotRadius,
                  color: primaryColor.withOpacity(1),
                ),
              ),
              Transform.translate(
                offset:
                    Offset(radius * cos(8 * pi / 4), radius * sin(8 * pi / 4)),
                child: Dot(
                  radius: dotRadius,
                  color: primaryColor.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;
  const Dot({
    Key? key,
    required this.radius,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
