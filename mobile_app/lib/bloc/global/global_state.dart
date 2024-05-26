part of 'global_bloc.dart';

@immutable
class GlobalState {
  final BVUser? user;
  final List<BVUser>? users;

  const GlobalState({
    this.user,
    this.users,
  });

  const GlobalState.initial()
      : user = null,
        users = null;

  GlobalState copyWith({
    BVUser? user,
    List<BVUser>? users,
  }) {
    return GlobalState(
      user: user ?? this.user,
      users: users ?? this.users,
    );
  }
}
