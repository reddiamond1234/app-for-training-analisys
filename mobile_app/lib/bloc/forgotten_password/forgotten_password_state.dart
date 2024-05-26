part of 'forgotten_password_bloc.dart';

@immutable
class ForgottenPasswordState {
  final Failure? failure;
  final bool? isSubmitSuccessful;
  final bool isButtonEnabled;

  const ForgottenPasswordState({
    this.failure,
    this.isSubmitSuccessful,
    required this.isButtonEnabled,
  });

  const ForgottenPasswordState.initial()
      : failure = null,
        isSubmitSuccessful = false,
        isButtonEnabled = false;

  ForgottenPasswordState copyWith({
    Failure? failure,
    bool? isSubmitSuccessful,
    bool? isButtonEnabled,
  }) {
    return ForgottenPasswordState(
      failure: failure,
      isSubmitSuccessful: isSubmitSuccessful ?? this.isSubmitSuccessful,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }
}
