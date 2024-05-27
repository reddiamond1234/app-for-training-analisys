import 'package:flutter/material.dart';

class FDDoubleColumn extends StatelessWidget {
  const FDDoubleColumn({
    super.key,
    required this.children,
    this.padding,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    // final bool isLargeScreen = MediaQuery.of(context).size.width > 600;
    return Column(
      children: [
        for (int i = 0; i < children.length; i += 2)
          Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(child: children[i]),
                const SizedBox(width: 20),
                if (i + 1 < children.length)
                  Expanded(child: children[i + 1])
                else
                  const Spacer()
              ],
            ),
          ),
      ],
    );
  }
}
