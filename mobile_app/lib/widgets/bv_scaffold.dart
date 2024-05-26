import 'package:flutter/material.dart';
import 'package:training_app/style/colors.dart';

import 'fd_app_bar.dart';

class BVScaffold extends StatelessWidget {
  const BVScaffold({
    super.key,
    this.appBarColor = BVColors.background,
    required this.body,
    this.showLeading = true,
    this.appBar,
  });

  final Color appBarColor;
  final Widget body;
  final bool showLeading;
  final PreferredSizeWidget? appBar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          FDAppBar(
            color: appBarColor,
            showLeading: showLeading,
          ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              body,
              SizedBox(height: MediaQuery.of(context).padding.bottom + 40),
            ],
          ),
        ),
      ),
    );
  }
}
