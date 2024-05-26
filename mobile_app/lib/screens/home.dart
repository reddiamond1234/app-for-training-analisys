import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../bloc/global/global_bloc.dart';
import '../models/user.dart';
import '../style/colors.dart';
import '../style/icons.dart';
import 'tabs/home_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: DefaultTabController(
        length: 3,
        initialIndex: 0,
        key: key,
        child: _HomeScreen(key: key),
      ),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen({super.key});

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  bool showTreasureHunt = false;
  StreamSubscription? _deepLinkStreamSubscription;
  void setShowTreasureHunt(bool value) {
    if (!mounted) return;
    setState(() {
      showTreasureHunt = value;
    });
  }

  @override
  void initState() {
    context.read<GlobalBloc>().selectedHomeTabStream.listen((index) {
      if (!mounted) return;
      DefaultTabController.maybeOf(context)?.animateTo(index);
    });

    super.initState();
  }

  @override
  void dispose() {
    _deepLinkStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BVUser? user = context.watch<GlobalBloc>().state.user;
    return Scaffold(
      /* floatingActionButton: user?.isAdmin != true
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: FloatingActionButton.extended(
                backgroundColor: BVColors.red,
                onPressed: () =>
                    Navigator.of(context).pushNamed(BVRoutes.scanCodeAdmin),
                label: const Text(
                  "SKENIRAJ",
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                ),
              ),
            ),*/
      body: Scaffold(
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        /* floatingActionButton: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(BVRoutes.scanQrCode),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(
                color: BVColors.red,
              ),
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: BVColors.red,
              ),
              padding: const EdgeInsets.all(15),
              child: SvgPicture.asset(BVIcons.qrCodeScan, width: 25),
            ),
          ),
        ),*/
        body: const HomeTabBody(),
        bottomNavigationBar: BVBottomNavigationBar(
          tabController: DefaultTabController.of(context),
        ),
      ),
    );
  }
}

class HomeTabBody extends StatelessWidget {
  const HomeTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: DefaultTabController.of(context),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        HomeTab(),
        Container(
          color: Colors.purple,
        ),
        Container(
          color: Colors.blue,
        )
      ],
    );
  }
}

class BVBottomNavigationBar extends StatefulWidget {
  const BVBottomNavigationBar({super.key, required this.tabController});

  final TabController tabController;

  @override
  State<BVBottomNavigationBar> createState() => _BVBottomNavigationBarState();
}

class _BVBottomNavigationBarState extends State<BVBottomNavigationBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      setState(() => selectedIndex = widget.tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final TabController tabController = DefaultTabController.of(context);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          elevation: 5,
          backgroundColor: Colors.white,
          selectedLabelStyle: const TextStyle(color: BVColors.red),
          unselectedLabelStyle: const TextStyle(
            color: BVColors.text,
          ),
          currentIndex: selectedIndex,
          onTap: (index) {
            tabController.animateTo(index);
          },
          selectedFontSize: 10,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                width: 25,
                BVIcons.home,
                color: BVColors.text,
              ),
              activeIcon: SvgPicture.asset(
                width: 25,
                BVIcons.home,
                color: BVColors.red,
              ),
              label: translate("bottom_nav_bar.home"),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                width: 25,
                BVIcons.health,
                color: BVColors.text,
              ),
              activeIcon: SvgPicture.asset(
                width: 25,
                BVIcons.health,
                color: BVColors.red,
              ),
              label: translate("bottom_nav_bar.form"),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                width: 25,
                BVIcons.statistics,
                color: BVColors.text,
              ),
              activeIcon: SvgPicture.asset(
                width: 25,
                BVIcons.statistics,
                color: BVColors.red,
              ),
              label: translate("bottom_nav_bar.statistics"),
            ),
          ],
        ),
      ),
    );
  }
}
