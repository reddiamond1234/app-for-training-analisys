import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../services/firebase_auth_service.dart';
import '../../util/either.dart';
import '../../util/failures/failure.dart';

part 'forgotten_password_event.dart';
part 'forgotten_password_state.dart';

class ForgottenPasswordBloc
    extends Bloc<_ForgottenPasswordEvent, ForgottenPasswordState> {
  final FirebaseAuthService _firebaseAuthService;
  late final TextEditingController _emailEditingController;

  TextEditingController get emailEditingController => _emailEditingController;

  ForgottenPasswordBloc({
    required FirebaseAuthService firebaseAuthService,
  })  : _firebaseAuthService = firebaseAuthService,
        _emailEditingController = TextEditingController(),
        super(const ForgottenPasswordState.initial()) {
    on<_ForgottenPasswordCompleted>(_onForgottenPasswordCompleted);
    on<_EmailChangedEvent>(_onEmailChanged);
  }

  // PUBLIC API
  Future<void> submitPressed() async {
    final Either<Failure, void> voidOrFailure =
        await _firebaseAuthService.requestPasswordReset(
      email: _emailEditingController.text,
    );

    add(_ForgottenPasswordCompleted(
      failure: voidOrFailure.isError() ? voidOrFailure.error : null,
    ));
  }

  void onChanged() => add(const _EmailChangedEvent());

  Future<FutureOr<void>> _onForgottenPasswordCompleted(
    _ForgottenPasswordCompleted event,
    Emitter<ForgottenPasswordState> emit,
  ) async {
    emit(state.copyWith(
      isSubmitSuccessful: event.failure == null,
      failure: event.failure,
    ));
  }

  FutureOr<void> _onEmailChanged(
    _EmailChangedEvent event,
    Emitter<ForgottenPasswordState> emit,
  ) {
    if (shouldButtonBeEnabled()) {
      if (state.isButtonEnabled) return null;
      emit(state.copyWith(isButtonEnabled: true));
    } else if (state.isButtonEnabled) {
      emit(state.copyWith(isButtonEnabled: false));
    }
  }

  bool shouldButtonBeEnabled() {
    return (_emailEditingController.text.isNotEmpty);
  }
}
