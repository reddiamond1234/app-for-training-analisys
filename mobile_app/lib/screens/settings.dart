import 'package:flutter/cupertino.dart';
import 'package:training_app/widgets/bv_scaffold.dart';
import 'package:training_app/widgets/fd_app_bar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BVScaffold(
      appBar: FDAppBar(
        title: "Nastavitve",
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
