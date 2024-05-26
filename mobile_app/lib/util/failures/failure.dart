abstract class Failure {
  const Failure();

  @override
  String toString() => 'Napaka pri pridobivanju podatkov';
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();
}

class NotFoundFailure extends Failure {
  const NotFoundFailure();
}

class ToJsonFailure extends Failure {
  const ToJsonFailure();
}

class FromJsonFailure extends Failure {
  const FromJsonFailure();
}

class BackendFailure extends Failure {
  const BackendFailure();
}

class UnvalidatedFailure extends Failure {
  const UnvalidatedFailure();
}

class WrongCountryFailure extends Failure {
  const WrongCountryFailure();
}

class NoPhoneNumberFailure extends Failure {
  const NoPhoneNumberFailure();
}

class NoProductFoundFailure extends Failure {
  const NoProductFoundFailure();
}

class TimeOutFailure extends Failure {
  const TimeOutFailure();
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure();
}

class NotEnoughProductInStockFailure extends Failure {
  const NotEnoughProductInStockFailure();
}

class OldLocationNotFound extends Failure {
  const OldLocationNotFound();
}

class PdfDownloadFailure extends Failure {
  const PdfDownloadFailure();
}

class UserInformationFetchFailure extends Failure {
  const UserInformationFetchFailure();

  @override
  String toString() => 'Napaka pri pridobivanju podatkov o uporabniku';
}

class ClientsFetchFailure extends Failure {
  const ClientsFetchFailure();

  @override
  String toString() => 'Napaka pri pridobivanju podatkov o strankah';
}

class UrlLaunchFailure extends Failure {
  const UrlLaunchFailure();

  @override
  String toString() => 'Napaka pri odpiranju povezave';
}

class NewCuttingListFailure extends Failure {
  const NewCuttingListFailure();

  @override
  String toString() => 'Napaka pri ustvarjanju novega lepljenca';
}

class LocationFailure extends Failure {
  final String? message;
  const LocationFailure({this.message});
}

class LocationFailureIOS extends Failure {
  final String? message;
  const LocationFailureIOS({this.message});
}

class AttachmentUploadFailure extends Failure {
  const AttachmentUploadFailure();
}

class ActiveIssuingNoteFailure extends Failure {
  const ActiveIssuingNoteFailure();
}

class SendMessageFailure extends Failure {
  final String docId;
  const SendMessageFailure({required this.docId});
}
