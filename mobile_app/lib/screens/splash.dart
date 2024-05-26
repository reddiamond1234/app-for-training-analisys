import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../bloc/global/global_bloc.dart';
import '../bloc/splash/splash_bloc.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_database_service.dart';
import '../style/colors.dart';
import '../widgets/native_dialog.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => SplashBloc(
        firebaseDatabaseService: FirebaseDatabaseService.instance,
        firebaseAuthService: FirebaseAuthService.instance,
        globalBloc: context.read<GlobalBloc>(),
      ),
      child: const _SplashScreen(),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SplashBloc bloc = BlocProvider.of<SplashBloc>(context);

    return BlocConsumer<SplashBloc, SplashState>(
      bloc: bloc,
      listener: (context, state) async {
        if (state.routeToPush != null) {
          Navigator.pushReplacementNamed(context, state.routeToPush!);
        } else if (state.failure != null) {
          showNativeRetryDialog(
            context,
            translate("splash_screen.failure"),
            state.failure.toString(),
            bloc.retry,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: BVColors.red,
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.07,
                  ),
                  child: Icon(
                    Icons.directions_bike_rounded,
                    weight: MediaQuery.of(context).size.height * 0.25,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
