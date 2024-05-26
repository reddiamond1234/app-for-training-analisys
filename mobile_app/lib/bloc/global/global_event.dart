part of 'global_bloc.dart';

@immutable
abstract class GlobalEvent {
  const GlobalEvent();
}

class _InitializeEvent extends GlobalEvent {
  final BVUser user;

  const _InitializeEvent({
    required this.user,
  });
}

class _SignOutEvent extends GlobalEvent {
  const _SignOutEvent();
}

class _UpdateUserEvent extends GlobalEvent {
  final BVUser user;
  const _UpdateUserEvent(this.user);
}

class _UsersChanged extends GlobalEvent {
  final List<BVUser?> users;
  const _UsersChanged(this.users);
}
