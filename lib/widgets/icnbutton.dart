// Packages
import 'package:flutter/material.dart';

// Helpers
import 'package:flutteruikit/urtils/helpers.dart';


class IcnButton extends StatefulWidget {
  final Duration colorchangeduration;
  final void Function()? onPressed;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final IconData? icondata;
  final double? size;
  final Color color;

  const IcnButton({
    super.key,
    this.icondata,
    this.onPressed,
    this.size,
    this.margin,
    this.padding,
    this.colorchangeduration = const Duration(milliseconds: 90),
    this.color = Colors.black
  });

  @override
  State<IcnButton> createState() => _IcnButtonState();
}

class _IcnButtonState extends State<IcnButton> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _colorTween;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: widget.colorchangeduration);
    _colorTween = ColorTween(
      begin: widget.color,
      end: Helpers.colorLighten(widget.color, 60)
    ).animate(_animationController!);

    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? const EdgeInsets.only(),
      child: AnimatedBuilder(
        animation: _colorTween!,
        builder: (context, child) => Listener(
          onPointerDown: (details) {
            _animationController!.forward();

            if (widget.onPressed != null) {
              widget.onPressed!();
            }
          },
          onPointerUp: (details) {
            _animationController!.reverse();
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: widget.padding,
              height: widget.size,
              width: widget.size,
              child: FittedBox(
                child: Icon(widget.icondata, color: _colorTween!.value)
              )
            )
          )
        )
      )
    );
  }
}
