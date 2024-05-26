part of 'login_bloc.dart';

@immutable
abstract class _LoginEvent {
  const _LoginEvent();
}

class _TogglePressedEvent extends _LoginEvent {
  const _TogglePressedEvent();
}

class _LoginPressedEvent extends _LoginEvent {
  final Either<Failure, void> userOrFailure;

  const _LoginPressedEvent(this.userOrFailure);
}

class _ForgottenPasswordPressedEvent extends _LoginEvent {
  const _ForgottenPasswordPressedEvent();
}

class _EmailOrPasswordChangedEvent extends _LoginEvent {
  const _EmailOrPasswordChangedEvent();
}
