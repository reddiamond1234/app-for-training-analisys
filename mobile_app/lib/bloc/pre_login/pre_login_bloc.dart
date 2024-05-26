import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../routes/routes.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firestore_users_service.dart';
import '../../services/local_storage_service.dart';
import '../../util/either.dart';
import '../../util/failures/failure.dart';
import '../global/global_bloc.dart';

part 'pre_login_event.dart';
part 'pre_login_state.dart';

class PreLoginBloc extends Bloc<_PreLoginEvent, PreLoginState> {
  final FirebaseAuthService _firebaseAuthService;
  final LocalStorageService _localStorageService;
  final FirestoreUsersService _firestoreUsersService = FirestoreUsersService();
  final GlobalBloc _globalBloc;

  PreLoginBloc({
    required FirebaseAuthService firebaseAuthService,
    required GlobalBloc globalBloc,
    required LocalStorageService localStorageService,
  })  : _firebaseAuthService = firebaseAuthService,
        _globalBloc = globalBloc,
        _localStorageService = localStorageService,
        super(const PreLoginState.initial()) {
    on<_EmailPasswordLoginPressed>(_onEmailPasswordLoginPressed);
    on<_FacebookLoginPressed>(_onFacebookLoginPressed);
    on<_RegistrationPressedEvent>(_onRegistrationPressed);
    on<_LoginPressedEvent>(_onLoginPressed);

    on<_IsLoadingChanged>(_isLoadingChanged);
  }

  // PUBLIC API
  void emailPasswordPressed() => add(const _EmailPasswordLoginPressed());

  void registrationPressed() => add(const _RegistrationPressedEvent());

  FutureOr<void> _onEmailPasswordLoginPressed(
    _EmailPasswordLoginPressed event,
    Emitter<PreLoginState> emit,
  ) {
    emit(state.copyWith(routeToPush: BVRoutes.login));
  }

  FutureOr<void> _onFacebookLoginPressed(
    _FacebookLoginPressed event,
    Emitter<PreLoginState> emit,
  ) {}

  FutureOr<void> _onRegistrationPressed(
    _RegistrationPressedEvent event,
    Emitter<PreLoginState> emit,
  ) {
    emit(state.copyWith(isRegistrationPressed: true));
  }

  // FOR LOGIN

  /// first argument is if it was successful
  /// second argument is if the user is new
  Future<(bool, bool)> afterSuccessfullySignedIn() async {
    final BVUser? user = _globalBloc.state.user;

    if (user == null) return (false, false);
    try {
      final Either<Failure, BVUser> userOrFailure =
          await _firestoreUsersService.getItem(_globalBloc.userId!);

      // check if the user is already in the database
      if (userOrFailure.isError()) {
        if (userOrFailure.error is NotFoundFailure) {
          final Either<Failure, void> voidOrFailure =
              await _firestoreUsersService.setDocument(
            user,
          );

          return (!voidOrFailure.isError(), true);
        }
        return (false, false);
      }
      return (true, false);
    } catch (_) {
      return (false, false);
    }
  }

  FutureOr<void> _onLoginPressed(
    _LoginPressedEvent event,
    Emitter<PreLoginState> emit,
  ) async {
    if (event.userOrFailure.isError()) {
      emit(state.copyWith(failure: event.userOrFailure.error));
    } else {
      emit(state.copyWith(isLoading: true));
      final (bool, bool) isSuccess = await afterSuccessfullySignedIn();

      if (!isSuccess.$1) {
        emit(state.copyWith(failure: const BackendFailure(), isLoading: false));
        return;
      }

      final Either<Failure, void> initOrFailure =
          await _globalBloc.initialize();

      emit(state.copyWith(
        failure: initOrFailure.isError() ? initOrFailure.error : null,
        routeToPush: initOrFailure.isError()
            ? null
            : isSuccess.$2
                ? BVRoutes.welcome
                : BVRoutes.home,
        isLoading: false,
      ));
    }
  }

  FutureOr<void> _isLoadingChanged(
    _IsLoadingChanged event,
    Emitter<PreLoginState> emit,
  ) {
    emit(state.copyWith(isLoading: event.isLoading));
  }
}
