import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../style/colors.dart';

class FDAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FDAppBar({
    super.key,
    this.color = BVColors.background,
    this.leading,
    this.showLeading = true,
    this.actions,
    this.title,
    this.centerIconPath,
    this.centerTitle = true,
    this.secondaryColor = BVColors.dark,
    this.fontSize,
    this.showTrailingCloseButton = false,
    this.titleColor,
    this.closingButtonColor,
    this.onClose,
  });

  final Color color;
  final Color secondaryColor;
  final Widget? leading;
  final bool showLeading;
  final bool showTrailingCloseButton;
  final Function()? onClose;
  final List<Widget>? actions;
  final String? title;
  final Color? titleColor;
  final Color? closingButtonColor;
  final String? centerIconPath;
  final bool centerTitle;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showLeading,
      leadingWidth: MediaQuery.of(context).size.width * 0.15,
      leading:
          showLeading ? (leading ?? BackButton(color: secondaryColor)) : null,
      backgroundColor: color,
      actions: [
        if (showTrailingCloseButton)
          CloseButton(
            color: closingButtonColor ?? Colors.white,
            onPressed: onClose,
          ),
        ...actions ?? []
      ],
      title: centerIconPath != null
          ? SvgPicture.asset(centerIconPath!, width: 30, height: 30)
          : title != null
              ? Text(
                  title!,
                  style: TextStyle(
                    color: titleColor ?? secondaryColor,
                    fontSize: fontSize,
                  ),
                  maxLines: 3,
                  textAlign: TextAlign.center,
                )
              : null,
      centerTitle: centerIconPath != null ? true : centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
