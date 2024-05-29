// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BVActivity _$BVActivityFromJson(Map<String, dynamic> json) => BVActivity(
      id: json['id'],
      name: json['name'] as String?,
      userId: json['userId'] as String,
      createdAt:
          const DateTimeConverter().fromJson(json['createdAt'] as String),
      km: json['km'] as String?,
      duration: json['duration'] as String?,
      elevationString: json['elevationString'] as String?,
      advancedStats: _$JsonConverterFromJson<String, AdvancedStats>(
          json['advancedStats'], const AdvancedStatsConverter().fromJson),
    );

Map<String, dynamic> _$BVActivityToJson(BVActivity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  val['userId'] = instance.userId;
  val['createdAt'] = const DateTimeConverter().toJson(instance.createdAt);
  writeNotNull('km', instance.km);
  writeNotNull('duration', instance.duration);
  writeNotNull('elevationString', instance.elevationString);
  writeNotNull(
      'advancedStats',
      _$JsonConverterToJson<String, AdvancedStats>(
          instance.advancedStats, const AdvancedStatsConverter().toJson));
  return val;
}

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

ActivityInsight _$ActivityInsightFromJson(Map<String, dynamic> json) =>
    ActivityInsight(
      tss: json['tss'] as num,
      form: json['form'] as num,
      ctl: json['ctl'] as num,
      atl: json['atl'] as num,
    );

Map<String, dynamic> _$ActivityInsightToJson(ActivityInsight instance) =>
    <String, dynamic>{
      'tss': instance.tss,
      'form': instance.form,
      'ctl': instance.ctl,
      'atl': instance.atl,
    };

AdvancedStats _$AdvancedStatsFromJson(Map<String, dynamic> json) =>
    AdvancedStats(
      timestamps: _$JsonConverterFromJson<List<dynamic>, List<DateTime>>(
          json['timestamps'], const DateTimeListConverter().fromJson),
      power: (json['power'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      speed: (json['speed'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      cadence: (json['cadence'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      elevation: (json['elevation'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      heartRate: (json['heartRate'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      zoneTimes: (json['zoneTimes'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      normalizedPower: (json['normalizedPower'] as num?)?.toDouble(),
      elevationClimbed: (json['elevationClimbed'] as num?)?.toDouble(),
      elevationDescended: (json['elevationDescended'] as num?)?.toDouble(),
      positions: (json['positions'] as List<dynamic>?)
          ?.map((e) => GeoPoint2.fromJson(e as Map<String, dynamic>))
          .toList(),
      insight: json['insight'] == null
          ? null
          : ActivityInsight.fromJson(json['insight'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdvancedStatsToJson(AdvancedStats instance) =>
    <String, dynamic>{
      'timestamps': _$JsonConverterToJson<List<dynamic>, List<DateTime>>(
          instance.timestamps, const DateTimeListConverter().toJson),
      'power': instance.power,
      'speed': instance.speed,
      'cadence': instance.cadence,
      'elevation': instance.elevation,
      'heartRate': instance.heartRate,
      'zoneTimes': instance.zoneTimes,
      'normalizedPower': instance.normalizedPower,
      'elevationClimbed': instance.elevationClimbed,
      'elevationDescended': instance.elevationDescended,
      'insight': instance.insight,
      'positions': instance.positions,
    };

GeoPoint2 _$GeoPoint2FromJson(Map<String, dynamic> json) => GeoPoint2(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$GeoPoint2ToJson(GeoPoint2 instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
