import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/models/activity.dart';
import 'package:training_app/services/firebase_database_service.dart';
import 'package:training_app/style/text_styles.dart';
import 'package:training_app/util/extensions.dart';

import '../../bloc/global/global_bloc.dart';
import '../../models/user.dart';
import '../../routes/routes.dart';
import '../../style/colors.dart';
import '../../util/functions.dart';
import '../../widgets/bv_scaffold.dart';
import '../../widgets/fd_app_bar.dart';
import '../../widgets/fd_rounded_box.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(
              Icons.refresh,
              color: BVColors.dark,
              size: 30,
            ),
          ),
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
          FirestoreListView<BVActivity>(
            key: ValueKey(user.id),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            query: FirebaseFirestore.instance
                .collection(FirebaseDocumentPaths.activities)
                .where('userId', isEqualTo: user.id)
                .orderBy('createdAt', descending: true)
                .withConverter(
                  fromFirestore: (a, b) =>
                      BVActivity.fromJson(a.data()!..['id'] = a.id),
                  toFirestore: (a, b) => a.toJson(),
                ),
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, snapshot) {
              return ActivityCard(
                activity: snapshot.data(),
                key: ValueKey(snapshot.data().id),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity});

  final BVActivity activity;
  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
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
            if (activity.km != null ||
                activity.duration != null ||
                activity.elevationString != null)
              DefaultTextStyle(
                style: BVTextStyles.infoSmall.copyWith(color: BVColors.dark),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${activity.km ?? "0"}km",
                    ),
                    const SizedBox(width: 10),
                    Text(
                      activity.duration ?? "0min",
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${activity.elevationClimbed?.toEUString() ?? "0"}m",
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
