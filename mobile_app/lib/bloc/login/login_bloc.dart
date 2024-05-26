import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';
import '../../routes/routes.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firebase_database_service.dart';
import '../../services/local_storage_service.dart';
import '../../util/either.dart';
import '../../util/failures/failure.dart';
import '../global/global_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<_LoginEvent, LoginState> {
  final FirebaseAuthService _firebaseAuthService;
  final FirebaseDatabaseService _firebaseDatabaseService;
  final GlobalBloc _globalBloc;
  final LocalStorageService _localStorageService;
  late final TextEditingController _emailEditingController;
  late final TextEditingController _passwordEditingController;

  TextEditingController get emailEditingController => _emailEditingController;

  TextEditingController get passwordEditingController =>
      _passwordEditingController;

  LoginBloc({
    required LocalStorageService localStorageService,
    required FirebaseDatabaseService firebaseDatabaseService,
    required FirebaseAuthService firebaseAuthService,
    required GlobalBloc globalBloc,
  })  : _firebaseAuthService = firebaseAuthService,
        _firebaseDatabaseService = firebaseDatabaseService,
        _globalBloc = globalBloc,
        _localStorageService = localStorageService,
        super(const LoginState.initial()) {
    _emailEditingController = TextEditingController();
    _passwordEditingController = TextEditingController();

    on<_TogglePressedEvent>(_onTogglePressed);
    on<_LoginPressedEvent>(_onLoginPressed);
    on<_ForgottenPasswordPressedEvent>(_onForgottenPasswordPressed);
    on<_EmailOrPasswordChangedEvent>(_onEmailOrPasswordChanged);

    //setBottomNavBarColor(Colors.white);
  }

  @override
  Future<void> close() async {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    await super.close();
  }

  // PUBLIC API
  void togglePassword() => add(const _TogglePressedEvent());

  Future<void> login() async {
    final Either<Failure, User?> userOrFailure =
        await _firebaseAuthService.signInWithEmailAndPassword(
      email: _emailEditingController.text,
      password: _passwordEditingController.text,
    );
    if (!isClosed) {
      add(_LoginPressedEvent(userOrFailure));
    }
  }

  void forgottenPassword() => add(const _ForgottenPasswordPressedEvent());

  void onChanged() => add(const _EmailOrPasswordChangedEvent());

  // HANDLERS

  // Toggle password visibility
  FutureOr<void> _onTogglePressed(
    _TogglePressedEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPasswordToggled: !state.isPasswordToggled));
  }

  FutureOr<void> _onLoginPressed(
    _LoginPressedEvent event,
    Emitter<LoginState> emit,
  ) async {
    if (event.userOrFailure.isError()) {
      emit(state.copyWith(failure: event.userOrFailure.error));
    } else {
      final Either<Failure, void> initOrFailure =
          await _globalBloc.initialize();

      emit(state.copyWith(
        failure: initOrFailure.isError() ? initOrFailure.error : null,
        isLoginSuccessful: !initOrFailure.isError(),
      ));
    }
  }

  FutureOr<void> _onEmailOrPasswordChanged(
      _EmailOrPasswordChangedEvent event, Emitter<LoginState> emit) {
    if (shouldButtonBeEnabled()) {
      if (state.isButtonEnabled) return null;
      emit(state.copyWith(isButtonEnabled: true));
    } else if (state.isButtonEnabled) {
      emit(state.copyWith(isButtonEnabled: false));
    }
  }

  FutureOr<void> _onForgottenPasswordPressed(
    _ForgottenPasswordPressedEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(routeToPush: BVRoutes.forgottenPassword));
  }

  Future<bool> afterSuccessfullySignedIn() async {
    final BVUser? user = _globalBloc.state.user;

    if (user == null) return false;
    try {
      final Either<Failure, BVUser> userOrFailure =
          await _firebaseDatabaseService.getUserData(_globalBloc.userId!);

      // check if the user is already in the database
      if (userOrFailure.isError()) {
        if (userOrFailure.error is NotFoundFailure) {
          final Either<Failure, void> voidOrFailure =
              await _firebaseDatabaseService.setDocument(
            'users/${user.id}',
            user.toJson(),
          );

          return !voidOrFailure.isError();
        }
        return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  bool shouldButtonBeEnabled() {
    return (_emailEditingController.text.isNotEmpty &&
        _passwordEditingController.text.isNotEmpty);
  }
}
