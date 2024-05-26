part of 'pre_login_bloc.dart';

@immutable
class PreLoginState {
  final Failure? failure;
  final String? routeToPush;
  final bool isRegistrationPressed;
  final bool? isNewUser;
  final bool isLoading;

  const PreLoginState({
    this.failure,
    required this.routeToPush,
    required this.isRegistrationPressed,
    this.isNewUser,
    required this.isLoading,
  });

  const PreLoginState.initial()
      : routeToPush = null,
        failure = null,
        isRegistrationPressed = false,
        isNewUser = null,
        isLoading = false;

  PreLoginState copyWith({
    bool? isLoading,
    Failure? failure,
    String? routeToPush,
    bool? isRegistrationPressed,
    bool? isNewUser,
  }) {
    return PreLoginState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
      routeToPush: routeToPush,
      isRegistrationPressed:
          isRegistrationPressed ?? this.isRegistrationPressed,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }
}
