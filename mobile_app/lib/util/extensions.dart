import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moment_dart/moment_dart.dart';

import 'constants.dart';

extension NumExtension on num {
  String toEUString() {
    try {
      return NumberFormat('##0.##', 'en').format(this);
    } catch (_) {
      return "";
    }
  }

  String toDuration() {
    try {
      final bool isNegative = this < 0;
      final num absoluteValue = isNegative ? -this : this;

      final int hours = absoluteValue ~/ 3600;
      final int minutes = (absoluteValue ~/ 60) % 60;
      final num seconds = absoluteValue % 60;

      final hourString = hours > 0 ? '${isNegative ? '-' : ''}$hours:' : '';
      final minuteString = '$minutes:';
      final secondString = seconds.toString().padLeft(2, '0');

      return '${isNegative ? "-" : ""}$hourString$minuteString$secondString';
    } catch (_) {
      return '';
    }
  }
}

extension DateExtenstion on DateTime {
  String toLocaleDate() {
    final DateFormat formatter = DateFormat('dd.MM.yyyy, HH:mm', 'sl');
    try {
      return formatter.format(this);
    } catch (_) {
      return "";
    }
  }

  String toStringDate() {
    final Moment moment = Moment(
      toLocal(),
      localization: MomentLocalizations.byLocale('sl'),
    );
    return moment.format(MOMENT_LONG_DATE_FORMAT);
  }
}

extension DurationExtension on Duration {
  String toSlovenianDuration() {
    try {
      final bool isNegative = this.isNegative;
      final Duration absoluteValue = isNegative ? -this : this;

      final int hours = absoluteValue.inHours;
      final int minutes = (absoluteValue.inMinutes) % 60;
      final int seconds = absoluteValue.inSeconds % 60;

      final hourString = hours > 0 ? '${isNegative ? '-' : ''}${hours}h' : '';
      final minuteString = '${minutes}min';

      return '${isNegative ? "-" : ""}$hourString$minuteString';
    } catch (_) {
      return '';
    }
  }
}

class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String dateTimeString) {
    return DateTime.parse(dateTimeString).toLocal();
  }

  @override
  String toJson(DateTime? dateTime) => dateTime?.toStringDate() ?? "";
}
