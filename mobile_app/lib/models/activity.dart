import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:training_app/util/extensions.dart';

import 'item_property.dart';

part 'activity.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class BVActivity extends ItemProperty implements Equatable {
  const BVActivity({
    required super.id,
    super.name,
    required this.userId,
    required this.createdAt,
    this.km,
    this.duration,
    this.elevationString,
    this.timestamps,
    this.power,
    this.speed,
    this.cadence,
    this.elevation,
    this.heartRate,
    this.zoneTimes,
    this.normalizedPower,
    this.elevationClimbed,
    this.elevationDescended,
    this.positions,
    this.insight,
  });

  final String userId;
  @DateTimeConverter()
  final DateTime createdAt;
  final String? km;
  final String? duration;
  final String? elevationString;

  // training data
  @DateTimeListConverter()
  final List<DateTime>? timestamps;
  final List<int>? power;
  final List<double>? speed;
  final List<int>? cadence;
  final List<double>? elevation;
  final List<int>? heartRate;
  final Map<String, double>? zoneTimes;
  final double? normalizedPower;
  final double? elevationClimbed;
  final double? elevationDescended;
  final ActivityInsight? insight;

  @GeoPointConverter()
  final List<GeoPoint>? positions;

  factory BVActivity.fromJson(Map<String, dynamic> json) =>
      _$BVActivityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BVActivityToJson(this);

  BVActivity copyWith({
    String? id,
    String? userId,
    DateTime? createdAt,
    String? km,
    String? duration,
    String? elevationString,
    List<DateTime>? timestamps,
    List<int>? power,
    List<double>? speed,
    List<int>? cadence,
    List<double>? elevation,
    List<int>? heartRate,
    Map<String, double>? zoneTimes,
    double? normalizedPower,
    double? elevationClimbed,
    double? elevationDescended,
    List<GeoPoint>? positions,
    ActivityInsight? insight,
  }) {
    return BVActivity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      km: km ?? this.km,
      duration: duration ?? this.duration,
      elevationString: elevationString ?? this.elevationString,
      timestamps: timestamps ?? this.timestamps,
      power: power ?? this.power,
      speed: speed ?? this.speed,
      cadence: cadence ?? this.cadence,
      elevation: elevation ?? this.elevation,
      heartRate: heartRate ?? this.heartRate,
      zoneTimes: zoneTimes ?? this.zoneTimes,
      normalizedPower: normalizedPower ?? this.normalizedPower,
      elevationClimbed: elevationClimbed ?? this.elevationClimbed,
      elevationDescended: elevationDescended ?? this.elevationDescended,
      positions: positions ?? this.positions,
      insight: insight ?? this.insight,
    );
  }

  @override
  List<Object?> get props =>
      [id, userId, createdAt, km, duration, elevationString];
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

class DateTimeListConverter
    implements JsonConverter<List<DateTime>, List<dynamic>> {
  const DateTimeListConverter();

  @override
  List<DateTime> fromJson(List<dynamic> dateTimeString) {
    return dateTimeString.map((e) => DateTime.parse(e).toLocal()).toList();
  }

  @override
  List<String> toJson(List<DateTime>? dateTime) =>
      dateTime?.map((e) => e.toStringDate()).toList() ?? [];
}

class GeoPointConverter
    implements JsonConverter<List<GeoPoint>, List<dynamic>> {
  const GeoPointConverter();

  @override
  List<GeoPoint> fromJson(List<dynamic> geoPoint) {
    return geoPoint.map((e) {
      final GeoPoint point = e as GeoPoint;
      return point;
    }).toList();
  }

  @override
  List<GeoPoint> toJson(List<GeoPoint> geoPoint) => geoPoint;
}

@JsonSerializable()
class ActivityInsight {
  final num tss;
  final num form;
  final num ctl;
  final num atl;

  ActivityInsight({
    required this.tss,
    required this.form,
    required this.ctl,
    required this.atl,
  });

  factory ActivityInsight.fromJson(Map<String, dynamic> json) =>
      _$ActivityInsightFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityInsightToJson(this);
}
