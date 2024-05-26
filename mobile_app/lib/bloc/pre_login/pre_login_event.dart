part of 'pre_login_bloc.dart';

@immutable
abstract class _PreLoginEvent {
  const _PreLoginEvent();
}

class _EmailPasswordLoginPressed extends _PreLoginEvent {
  const _EmailPasswordLoginPressed();
}

class _FacebookLoginPressed extends _PreLoginEvent {
  const _FacebookLoginPressed();
}

class _RegistrationPressedEvent extends _PreLoginEvent {
  const _RegistrationPressedEvent();
}

class _LoginPressedEvent extends _PreLoginEvent {
  final Either<Failure, BVUser> userOrFailure;

  const _LoginPressedEvent(this.userOrFailure);
}

class _IsLoadingChanged extends _PreLoginEvent {
  final bool isLoading;

  const _IsLoadingChanged(this.isLoading);
}
