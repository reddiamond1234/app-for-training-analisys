import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moment_dart/moment_dart.dart';

import '../util/constants.dart';
import 'item_property.dart';

part 'activity.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Activity extends ItemProperty {
  const Activity({
    required super.id,
    super.name,
    required this.userId,
    required this.createdAt,
    this.km,
    this.duration,
    this.elevation,
  });

  final String userId;
  @DateTimeConverter()
  final DateTime createdAt;
  final String? km;
  final String? duration;
  final String? elevation;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ActivityToJson(this);
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
