// Packages
import 'package:flutter/material.dart';

// Helpers
import 'package:flutteruikit/urtils/helpers.dart';


class LinkButton extends StatefulWidget {
  final Duration? colorchangeduration;
  final EdgeInsetsGeometry? padding;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? margin;
  final String? labelText;
  final Color? textcolor;

  const LinkButton({super.key, this.onPressed, this.margin, this.labelText, this.colorchangeduration, this.padding, this.textcolor});

  @override
  State<LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<LinkButton> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation?           _colorTween;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: widget.colorchangeduration ?? const Duration(milliseconds: 90));

    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _colorTween = ColorTween(
      begin: widget.textcolor ?? Colors.blue, 
      end: widget.textcolor != null ? Helpers.colorLighten(widget.textcolor!, 50) : Helpers.colorLighten(Colors.blue, 50))
    .animate(_animationController!);
  
    return Padding(
      padding: widget.margin ?? const EdgeInsets.only(),

      // AnimationBuilder for color change when pressed
      child: AnimatedBuilder(
        animation: _colorTween!,

        // Listener to listen when mouse pressed LinkButton
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

          // MouseRegion to change mouse pointer to a pointer
          child: MouseRegion(
            cursor: SystemMouseCursors.click,

            // Actual LinkButton Design
            child: Container(
              padding: widget.padding,
              child: Center(
                child: Text(
                  widget.labelText ?? "LinkButton",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: _colorTween!.value,
                    fontSize: 18
                  ),
                )
              )
            )
          )
        )
      )
    );
  }
}
