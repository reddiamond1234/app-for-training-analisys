part of 'register_bloc.dart';

@immutable
abstract class _RegisterEvent {
  const _RegisterEvent();
}

class _RegistrationPressedEvent extends _RegisterEvent {
  final Either<Failure, BVUser> userOrFailure;

  const _RegistrationPressedEvent(this.userOrFailure);
}

class _TextFieldChangedEvent extends _RegisterEvent {
  const _TextFieldChangedEvent();
}

class _LoginPressedEvent extends _RegisterEvent {
  const _LoginPressedEvent();
}

class _TogglePasswordPressedEvent extends _RegisterEvent {
  const _TogglePasswordPressedEvent();
}
