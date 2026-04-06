import 'package:flutter/material.dart';

class AnimatedDonut extends StatefulWidget {
  final double size;
  final double target;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;
  final Widget center;
  final Duration duration;

  const AnimatedDonut({
    super.key,
    required this.size,
    required this.target,
    required this.center,
    this.strokeWidth = 16,
    this.trackColor = const Color(0xFFE6E6E6),
    this.progressColor = Colors.red,
    this.duration = const Duration(milliseconds: 1400),
  });

  @override
  State<AnimatedDonut> createState() => _AnimatedDonutState();
}

class _AnimatedDonutState extends State<AnimatedDonut>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final value = widget.target * _animation.value;
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: 1,
                strokeWidth: widget.strokeWidth,
                color: widget.trackColor,
              ),
              CircularProgressIndicator(
                value: value.clamp(0.0, 1.0),
                strokeWidth: widget.strokeWidth,
                color: widget.progressColor,
                strokeCap: StrokeCap.round,
              ),
              widget.center,
            ],
          ),
        );
      },
    );
  }
}
