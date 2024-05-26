import 'package:flutter/cupertino.dart';
import 'package:training_app/models/activity.dart';
import 'package:training_app/widgets/bv_scaffold.dart';
import 'package:training_app/widgets/fd_app_bar.dart';

class ActivityDetailsScreen extends StatelessWidget {
  const ActivityDetailsScreen({
    super.key,
    required this.activity,
  });
  final BVActivity activity;

  @override
  Widget build(BuildContext context) {
    return const BVScaffold(
        appBar: FDAppBar(
          title: "Podrobnost aktivnosti",
        ),
        body: Column(
          children: [],
        ));
  }
}
