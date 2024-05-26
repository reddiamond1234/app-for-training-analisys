import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/models/activity.dart';
import 'package:training_app/services/firebase_database_service.dart';
import 'package:training_app/style/text_styles.dart';

import '../../bloc/global/global_bloc.dart';
import '../../models/user.dart';
import '../../routes/routes.dart';
import '../../style/colors.dart';
import '../../util/functions.dart';
import '../../widgets/bv_scaffold.dart';
import '../../widgets/fd_app_bar.dart';
import '../../widgets/fd_rounded_box.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final BVUser? user = context.watch<GlobalBloc>().state.user;
    if (user == null) return const SizedBox();

    return BVScaffold(
      appBarColor: BVColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(BVRoutes.addActivity),
        backgroundColor: BVColors.dark,
        child: const Icon(
          Icons.add_outlined,
          color: BVColors.background,
        ),
      ),
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
          FirestoreListView<Activity>(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            query: FirebaseFirestore.instance
                .collection(FirebaseDocumentPaths.activities)
                .where('userId', isEqualTo: user.id)
                .withConverter(
                  fromFirestore: (a, b) =>
                      Activity.fromJson(a.data()!..['id'] = a.id),
                  toFirestore: (a, b) => a.toJson(),
                ),
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, snapshot) {
              return ActivityCard(activity: snapshot.data());
            },
          ),
        ],
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity});

  final Activity activity;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: FDRoundedBox(
        onTap: () => Navigator.of(context)
            .pushNamed(BVRoutes.activityDetails, arguments: activity),
        color: BVColors.turquoiseLight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              activity.createdAt.toLocaleDate(),
              style: BVTextStyles.infoSmall.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              activity.name ?? "",
              style: BVTextStyles.heading02,
            ),
            const SizedBox(height: 10),
            DefaultTextStyle(
              style: BVTextStyles.infoSmall.copyWith(color: BVColors.dark),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    activity.km ?? "",
                  ),
                  const SizedBox(width: 10),
                  Text(
                    activity.duration ?? "",
                  ),
                  const SizedBox(width: 10),
                  Text(
                    activity.elevation ?? "",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
