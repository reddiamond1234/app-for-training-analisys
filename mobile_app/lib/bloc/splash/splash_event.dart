part of 'splash_bloc.dart';

@immutable
abstract class SplashEvent {
  const SplashEvent();
}

class _Initialize extends SplashEvent {
  const _Initialize();
}
