part of 'login_bloc.dart';

@immutable
class LoginState {
  final Failure? failure;

  final bool isPasswordToggled;
  final bool isButtonEnabled;
  final bool? isLoginSuccessful;
  final String? routeToPush;

  const LoginState({
    this.failure,
    required this.isPasswordToggled,
    required this.isButtonEnabled,
    this.isLoginSuccessful,
    this.routeToPush,
  });

  const LoginState.initial()
      : failure = null,
        isPasswordToggled = true,
        isButtonEnabled = false,
        isLoginSuccessful = null,
        routeToPush = null;

  LoginState copyWith({
    Failure? failure,
    bool? isPasswordToggled,
    bool? isButtonEnabled,
    bool? isLoginSuccessful,
    String? routeToPush,
  }) {
    return LoginState(
      failure: failure,
      isPasswordToggled: isPasswordToggled ?? this.isPasswordToggled,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      isLoginSuccessful: isLoginSuccessful ?? this.isLoginSuccessful,
      routeToPush: routeToPush,
    );
  }
}
