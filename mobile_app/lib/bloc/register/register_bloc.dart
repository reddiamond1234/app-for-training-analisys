import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../models/user.dart';
import '../../routes/routes.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firestore_users_service.dart';
import '../../util/either.dart';
import '../../util/failures/failure.dart';
import '../global/global_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<_RegisterEvent, RegisterState> {
  final FirebaseAuthService _firebaseAuthService;
  final FirestoreUsersService _firestoreUsersService = FirestoreUsersService();

  late final TextEditingController _nameEditingController;
  late final TextEditingController _emailEditingController;
  late final TextEditingController _passwordEditingController;

  TextEditingController get nameEditingController => _nameEditingController;

  TextEditingController get emailEditingController => _emailEditingController;

  TextEditingController get passwordEditingController =>
      _passwordEditingController;

  final GlobalBloc globalBloc;

  RegisterBloc({
    required FirebaseAuthService firebaseAuthService,
    required this.globalBloc,
  })  : _firebaseAuthService = firebaseAuthService,
        _nameEditingController = TextEditingController(),
        _emailEditingController = TextEditingController(),
        _passwordEditingController = TextEditingController(),
        super(const RegisterState.initial()) {
    on<_RegistrationPressedEvent>(_onRegistrationPressed);
    on<_TextFieldChangedEvent>(_textFieldChanged);
    on<_LoginPressedEvent>(_onLoginPressed);
    on<_TogglePasswordPressedEvent>(_onTogglePasswordPressed);
  }

  // PUBLIC API
  Future<void> registrationPressed() async {
    final Either<Failure, User?> authUserOrFailure =
        await _firebaseAuthService.createUserWithEmailAndPassword(
      email: _emailEditingController.text,
      password: _passwordEditingController.text,
    );

    if (authUserOrFailure.isError()) {
      log("ERROR: ${authUserOrFailure.error}");
      if (!isClosed) {
        final Either<Failure, BVUser> failure = error(authUserOrFailure.error);
        add(_RegistrationPressedEvent(failure));
      }
    } else {
      final BVUser user = BVUser(
        id: authUserOrFailure.value!.uid,
        email: _emailEditingController.text,
        name: _nameEditingController.text,
        deleted: false,
      );

      final Either<Failure, BVUser> userOrFailure =
          await _firestoreUsersService.setDocument(user);

      await globalBloc.initialize();

      if (!isClosed) {
        add(_RegistrationPressedEvent(userOrFailure));
      }
    }
  }

  void onChanged() => add(const _TextFieldChangedEvent());

  void togglePassword() => add(const _TogglePasswordPressedEvent());

  void loginPressed() => add(const _LoginPressedEvent());

  // HANDLERS
  FutureOr<void> _onRegistrationPressed(
    _RegistrationPressedEvent event,
    Emitter<RegisterState> emit,
  ) async {
    if (event.userOrFailure.isError()) {
      emit(state.copyWith(failure: event.userOrFailure.error));
    } else {
      await globalBloc.initialize();
      emit(state.copyWith(
        failure: null,
        isRegistrationSuccessful: true,
      ));
    }
  }

  FutureOr<void> _onTogglePasswordPressed(
    _TogglePasswordPressedEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(isPasswordToggled: !state.isPasswordToggled));
  }

  FutureOr<void> _textFieldChanged(
    _TextFieldChangedEvent event,
    Emitter<RegisterState> emit,
  ) {
    if (shouldButtonBeEnabled()) {
      if (state.isButtonEnabled) return null;
      emit(state.copyWith(isButtonEnabled: true));
    } else if (state.isButtonEnabled) {
      emit(state.copyWith(isButtonEnabled: false));
    }
  }

  FutureOr<void> _onLoginPressed(
    _LoginPressedEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(routeToPush: BVRoutes.login));
  }

  bool shouldButtonBeEnabled() {
    return (_emailEditingController.text.isNotEmpty &&
        _passwordEditingController.text.isNotEmpty &&
        _nameEditingController.text.isNotEmpty);
  }
}
