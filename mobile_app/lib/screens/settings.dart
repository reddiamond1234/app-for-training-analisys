import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/bloc/global/global_bloc.dart';
import 'package:training_app/widgets/bv_scaffold.dart';
import 'package:training_app/widgets/fd_app_bar.dart';
import 'package:training_app/widgets/fd_button.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BVScaffold(
      appBar: FDAppBar(
        title: "Nastavitve",
      ),
      body: Column(
        children: [
          FDPrimaryButton(
            text: "Sign out",
            onPressed: () async {
              context.read<GlobalBloc>().signOut();
            },
          )
        ],
      ),
    );
  }
}
