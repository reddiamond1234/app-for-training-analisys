import 'package:flutter/material.dart';

class FDRoundedBox extends StatelessWidget {
  const FDRoundedBox({
    super.key,
    this.color,
    this.borderRadius,
    this.child,
    this.width,
    this.height,
    this.border,
    this.padding,
    this.onTap,
    this.boxShadow,
  });

  final Color? color;
  final double? borderRadius;
  final Widget? child;
  final double? width;
  final double? height;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final Function()? onTap;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        border: border,
        boxShadow: boxShadow,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: child,
        ),
      ),
    );
  }
}
