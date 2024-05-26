import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../style/text_styles.dart';
import '../util/constants.dart';

class FDTextField extends StatelessWidget {
  final bool? obscureText;
  final String? hintText;
  final TextEditingController? controller;
  final String? content;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final Color? textColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? labelColor;
  final void Function(String?)? onChanged;
  final bool readOnly;
  final int? maxLines;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final int? minLines;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final bool isDense;
  final String? suffixText;

  const FDTextField({
    Key? key,
    this.onTap,
    this.obscureText,
    this.controller,
    this.content,
    this.suffixIcon,
    this.textInputType,
    this.textInputAction,
    this.textColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.labelColor,
    this.onChanged,
    this.readOnly = false,
    this.maxLines = 1,
    this.hintText,
    this.textAlign = TextAlign.start,
    this.contentPadding = defaultTextPadding,
    this.minLines,
    this.validator,
    this.isDense = false,
    this.suffixText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color defaultColor = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;
    const Color borderColor = BVColors.lines;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          onTap: onTap,
          validator: validator,
          minLines: minLines,
          textAlign: textAlign,
          readOnly: readOnly,
          onChanged: onChanged,
          keyboardType: textInputType,
          textInputAction: textInputAction,
          obscureText: obscureText ?? false,
          controller: controller ??
              (content == null ? null : TextEditingController(text: content)),
          maxLines: maxLines,
          style: TextStyle(
            color: textColor ?? defaultColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            errorMaxLines: 2,
            contentPadding: contentPadding,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: BVColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            labelStyle: TextStyle(color: labelColor ?? defaultColor),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: enabledBorderColor ?? borderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: focusedBorderColor ?? borderColor,
                width: readOnly ? 1 : 2,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            suffixText: suffixText,
            suffixIcon: suffixIcon,
            suffixStyle: BVTextStyles.info.copyWith(
              color: BVColors.text,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
