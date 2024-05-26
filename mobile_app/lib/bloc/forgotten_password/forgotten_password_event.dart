part of 'forgotten_password_bloc.dart';

@immutable
abstract class _ForgottenPasswordEvent {
  const _ForgottenPasswordEvent();
}

class _ForgottenPasswordCompleted extends _ForgottenPasswordEvent {
  final Failure? failure;
  const _ForgottenPasswordCompleted({this.failure});
}

class _EmailChangedEvent extends _ForgottenPasswordEvent {
  const _EmailChangedEvent();
}
