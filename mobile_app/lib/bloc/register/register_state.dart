part of 'register_bloc.dart';

@immutable
class RegisterState {
  final bool isLoading;
  final Failure? failure;

  final bool isPasswordToggled;
  final bool isButtonEnabled;
  final bool? isRegistrationSuccessful;
  final String? routeToPush;

  const RegisterState({
    required this.isLoading,
    this.failure,
    required this.isPasswordToggled,
    required this.isButtonEnabled,
    this.isRegistrationSuccessful,
    this.routeToPush,
  });

  const RegisterState.initial()
      : isLoading = false,
        failure = null,
        isPasswordToggled = true,
        isButtonEnabled = false,
        isRegistrationSuccessful = null,
        routeToPush = null;

  RegisterState copyWith({
    bool? isLoading,
    bool? isButtonEnabled,
    Failure? failure,
    bool? isPasswordToggled,
    bool? isRegistrationSuccessful,
    String? routeToPush,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
      isPasswordToggled: isPasswordToggled ?? this.isPasswordToggled,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      isRegistrationSuccessful:
          isRegistrationSuccessful ?? this.isRegistrationSuccessful,
      routeToPush: routeToPush ?? this.routeToPush,
    );
  }
}
