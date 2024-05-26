import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/routes.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firebase_database_service.dart';
import '../../style/colors.dart';
import '../../util/either.dart';
import '../../util/failures/auth_failure.dart';
import '../../util/failures/failure.dart';
import '../../util/functions.dart';
import '../global/global_bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({
    required FirebaseAuthService firebaseAuthService,
    required FirebaseDatabaseService firebaseDatabaseService,
    required GlobalBloc globalBloc,
  })  : _globalBloc = globalBloc,
        super(SplashState.initial()) {
    on<_Initialize>(_onInitialize);

    add(const _Initialize());
  }

  final GlobalBloc _globalBloc;

  // PUBLIC API

  void retry() => add(const _Initialize());

  // HANDLERS
  FutureOr<void> _onInitialize(
    _Initialize event,
    Emitter<SplashState> emit,
  ) async {
    setBottomNavBarColor(BVColors.red);
    final Either<Failure, void> voidOrFailure = await _globalBloc.initialize();

    await Future<void>.delayed(const Duration(seconds: 1));

    if (voidOrFailure.isError()) {
      final Failure failure = voidOrFailure.error;

      if (failure is! NotLoggedInFailure) {
        _globalBloc.signOut();
      }
      emit(state.copyWith(routeToPush: BVRoutes.preLogin));
    } else {
      emit(state.copyWith(routeToPush: BVRoutes.home));
    }
  }
}
