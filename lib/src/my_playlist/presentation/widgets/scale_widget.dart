import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget scaleWidget(
    {required Widget child,
    required Function onTap,
    double scale = 0.9,
    int time = 100,
    bool isWait = false}) {
  bool pressed = false;
  return StatefulBuilder(
      builder: (context, setState) => GestureDetector(
            onTap: () {
              setState(() => pressed = true);
              Future.delayed(Duration(milliseconds: time), () async {
                setState(() => pressed = false);
                if (isWait) {
                  onTap();
                } else {
                  Future.delayed(Duration(milliseconds: time), () async {
                    onTap();
                  });
                }
              });
            },
            child: AnimatedTransform(
              transform: Matrix4.diagonal3Values(
                  pressed ? scale : 1, pressed ? scale : 1, 1.0),
              transformHitTests: true,
              duration: Duration(milliseconds: time),
              curve: Curves.easeOut,
              alignment: Alignment.center,
              child: child,
            ),
          ));
}

class AnimatedTransform extends ImplicitlyAnimatedWidget {
  const AnimatedTransform({
    Key? key,
    this.transform,
    this.origin,
    this.alignment,
    this.transformHitTests = true,
    this.child,
    Curve curve = Curves.linear,
    required Duration duration,
  }) : super(
          key: key,
          curve: curve,
          duration: duration,
        );

  final Widget? child;

  final Offset? origin;

  final AlignmentGeometry? alignment;

  final bool? transformHitTests;

  final Matrix4? transform;

  @override
  AnimatedTransformState createState() => AnimatedTransformState();
}

class AnimatedTransformState
    extends AnimatedWidgetBaseState<AnimatedTransform> {
  AlignmentGeometryTween? _alignment;
  Matrix4Tween? _transform;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _alignment = visitor(
            _alignment,
            widget.alignment,
            (dynamic value) =>
                AlignmentGeometryTween(begin: value as AlignmentGeometry))
        as AlignmentGeometryTween;
    _transform = visitor(_transform, widget.transform,
            (dynamic value) => Matrix4Tween(begin: value as Matrix4))
        as Matrix4Tween;
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: _transform?.evaluate(animation) ?? Matrix4.zero(),
      alignment: _alignment?.evaluate(animation),
      origin: widget.origin,
      transformHitTests: widget.transformHitTests ?? true,
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<AlignmentGeometryTween>(
        'alignment', _alignment,
        showName: false, defaultValue: null));
    description
        .add(ObjectFlagProperty<Matrix4Tween>.has('transform', _transform));
  }
}
