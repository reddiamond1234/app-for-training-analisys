import 'failure.dart';

abstract class AuthFailure extends Failure {
  const AuthFailure();

  factory AuthFailure.fromStatusCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const InvalidEmailFailure();
      case 'wrong-password':
        return const WrongPasswordFailure();
      case 'user-not-found':
        return const UserNotFoundFailure();
      case 'user-disabled':
        return const UserDisabledFailure();
      case 'email-already-in-use':
        return const EmailAlreadyInUseFailure();
      case 'weak-password':
        return const WeakPasswordFailure();
      default:
        return const UnknownAuthFailure();
    }
  }
}

class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure();
}

class RequiredLoginFailure extends AuthFailure {
  const RequiredLoginFailure();
}

class TimeoutFailure extends AuthFailure {
  const TimeoutFailure();
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure();
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure();
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure();
}

class UserDisabledFailure extends AuthFailure {
  const UserDisabledFailure();
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure();
}

class WrongPasswordFailure extends AuthFailure {
  const WrongPasswordFailure();
}

class PasswordsDoNotMatchFailure extends AuthFailure {
  const PasswordsDoNotMatchFailure();
}

class NoTokenFoundFailure extends AuthFailure {
  const NoTokenFoundFailure();
}

class NotLoggedInFailure extends AuthFailure {
  const NotLoggedInFailure();

  @override
  String toString() => 'Niste prijavljeni';
}

class AccountExistsAuthFailure extends AuthFailure {
  const AccountExistsAuthFailure();
}

class InvalidCredentialAuthFailure extends AuthFailure {
  const InvalidCredentialAuthFailure();
}

class SignInBlocAbortedAuthFailure extends AuthFailure {
  const SignInBlocAbortedAuthFailure();
}

class OperationNotAllowedAuthFailure extends AuthFailure {
  const OperationNotAllowedAuthFailure();
}

class UserDisabledAuthFailure extends AuthFailure {
  const UserDisabledAuthFailure();
}

class UserNotFoundAuthFailure extends AuthFailure {
  const UserNotFoundAuthFailure();
}
