import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/bloc/global/global_bloc.dart';
import 'package:training_app/models/user.dart';
import 'package:training_app/routes/routes.dart';
import 'package:training_app/style/colors.dart';
import 'package:training_app/widgets/bv_scaffold.dart';
import 'package:training_app/widgets/fd_app_bar.dart';
import 'package:training_app/widgets/fd_rounded_box.dart';

import '../../util/functions.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final BVUser? user = context.watch<GlobalBloc>().state.user;
    if (user == null) return const SizedBox();

    return BVScaffold(
      appBarColor: BVColors.background,
      appBar: FDAppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: FDRoundedBox(
            borderRadius: 15,
            color: BVColors.dark,
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                getInitials(user.name!),
                maxLines: 1,
                style: const TextStyle(
                  color: BVColors.background,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        title: user.name!,
        titleColor: BVColors.dark,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(BVRoutes.settings),
            icon: const Icon(
              Icons.settings,
              color: BVColors.dark,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          Text("Home Tab"),
        ],
      ),
    );
  }
}
