part of 'splash_bloc.dart';

class SplashState {
  final String? routeToPush;

  final Failure? failure;

  const SplashState({
    this.routeToPush,
    this.failure,
  });

  SplashState.initial()
      : routeToPush = null,
        failure = null;

  SplashState copyWith({
    String? routeToPush,
    String? pushRoute,
    Failure? failure,
  }) {
    return SplashState(
      routeToPush: routeToPush ?? this.routeToPush,
      failure: failure,
    );
  }
}
