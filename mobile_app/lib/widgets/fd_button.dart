import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../style/colors.dart';
import '../style/text_styles.dart';
import '../util/functions.dart';
import 'fd_loading_indicator.dart';

class FDButton extends StatefulWidget {
  const FDButton({
    Key? key,
    this.text,
    this.child,
    this.buttonStyle,
    this.onPressed,
    this.enabled = true,
    this.width,
    this.height,
    this.textStyle,
    this.prefixIcon,
    this.expandWidth = true,
    this.prefixIconColor,
    EdgeInsets? padding,
  })  : assert(text == null || child == null),
        padding = padding ?? const EdgeInsets.all(14),
        super(key: key);

  final String? text;
  final Widget? child;
  final FutureOr Function()? onPressed;
  final bool enabled;
  final ButtonStyle? buttonStyle;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final String? prefixIcon;
  final Color? prefixIconColor;
  final bool expandWidth;
  final EdgeInsets padding;

  @override
  State<FDButton> createState() => _FDButtonState();
}

class _FDButtonState extends State<FDButton> {
  late bool isLoading;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  void toggleIsLoading() {
    if (mounted) {
      setState(() => isLoading = !isLoading);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? (widget.expandWidth ? double.infinity : null),
      height: widget.height,
      child: ElevatedButton(
        style: widget.buttonStyle ??
            ButtonStyle(
              splashFactory: InkSparkle.splashFactory,
              backgroundColor: MaterialStateProperty.all(
                widget.enabled ? BVColors.dark : BVColors.text.withOpacity(0.5),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
        onPressed: widget.enabled
            ? isLoading
                ? null
                : () async {
                    toggleIsLoading();
                    await widget.onPressed?.call();
                    toggleIsLoading();
                  }
            : null,
        child: Padding(
          padding: isLoading == true ? const EdgeInsets.all(7) : widget.padding,
          child: isLoading
              ? const FDLoadingIndicator(
                  dotRadius: 5,
                  radius: 14,
                  color: Colors.white,
                )
              : widget.child ??
                  Container(
                    child: widget.prefixIcon != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                widget.prefixIcon!,
                                colorFilter:
                                    getColorFilter(widget.prefixIconColor),
                                width: 22,
                                height: 22,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                widget.text!,
                                textAlign: TextAlign.center,
                                style: widget.textStyle ??
                                    BVTextStyles.primaryButtonStyle,
                              ),
                            ],
                          )
                        : Text(
                            widget.text!,
                            textAlign: TextAlign.center,
                            style: widget.textStyle ??
                                BVTextStyles.primaryButtonStyle,
                          ),
                  ),
        ),
      ),
    );
  }
}

class FDPrimaryButton extends StatelessWidget {
  const FDPrimaryButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.isBig = false,
    this.enabled = true,
    this.color,
    this.textColor,
    this.padding,
    this.expandWidth = true,
    this.prefixIcon,
    this.prefixIconColor,
    this.borderRadius,
    this.borderColor,
  }) : assert(text != null || child != null);

  final String? text;
  final Widget? child;
  final FutureOr Function()? onPressed;
  final bool isBig;
  final bool enabled;
  final Color? color;
  final Color? textColor;
  final EdgeInsets? padding;
  final bool expandWidth;
  final String? prefixIcon;
  final Color? prefixIconColor;
  final double? borderRadius;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return FDButton(
      enabled: enabled,
      prefixIcon: prefixIcon,
      prefixIconColor: prefixIconColor,
      text: text,
      expandWidth: expandWidth,
      height: isBig ? 65 : null,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 18),
      textStyle: BVTextStyles.name.copyWith(color: textColor ?? Colors.white),
      buttonStyle: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          enabled ? (color ?? BVColors.dark) : BVColors.text.withOpacity(0.65),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadius ?? 15),
          ),
        ),
      ),
      onPressed: () async => await onPressed?.call(),
      child: child,
    );
  }
}

class FDSecondaryButton extends StatelessWidget {
  const FDSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.prefixIcon,
    this.padding,
    this.iconColor,
    this.enabled = true,
  });

  final String text;
  final String? prefixIcon;
  final FutureOr Function()? onPressed;
  final EdgeInsets? padding;
  final Color? iconColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return FDButton(
      enabled: enabled,
      buttonStyle: ButtonStyle(
        elevation: const MaterialStatePropertyAll(0),
        backgroundColor: MaterialStatePropertyAll(
          enabled ? BVColors.background : BVColors.text.withOpacity(0.8),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: BVColors.text,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Stack(
        children: [
          if (prefixIcon != null)
            SvgPicture.asset(
              prefixIcon!,
              width: 24,
              color: iconColor,
            ),
          Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        ],
      ),
    );
  }
}
