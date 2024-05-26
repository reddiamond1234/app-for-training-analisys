// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['id'],
      name: json['name'] as String?,
      userId: json['userId'] as String,
      createdAt:
          const DateTimeConverter().fromJson(json['createdAt'] as String),
      km: json['km'] as String?,
      duration: json['duration'] as String?,
      elevation: json['elevation'] as String?,
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) {
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
  writeNotNull('elevation', instance.elevation);
  return val;
}
