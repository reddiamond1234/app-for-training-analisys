// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BVUser _$BVUserFromJson(Map<String, dynamic> json) => BVUser(
      id: json['id'],
      email: json['email'] as String,
      name: json['name'] as String?,
      deleted: json['deleted'] as bool?,
      isAdmin: json['isAdmin'] as bool?,
      weight: json['weight'] as num?,
      height: json['height'] as num?,
      age: json['age'] as num?,
      maxHr: json['maxHr'] as num?,
      zone1MinPower: json['zone1MinPower'] as num?,
      zone1MaxPower: json['zone1MaxPower'] as num?,
      zone2MinPower: json['zone2MinPower'] as num?,
      zone2MaxPower: json['zone2MaxPower'] as num?,
      zone3MinPower: json['zone3MinPower'] as num?,
      zone3MaxPower: json['zone3MaxPower'] as num?,
      zone4MinPower: json['zone4MinPower'] as num?,
      zone4MaxPower: json['zone4MaxPower'] as num?,
      zone5MinPower: json['zone5MinPower'] as num?,
      zone5MaxPower: json['zone5MaxPower'] as num?,
    );

Map<String, dynamic> _$BVUserToJson(BVUser instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  val['email'] = instance.email;
  writeNotNull('deleted', instance.deleted);
  writeNotNull('isAdmin', instance.isAdmin);
  writeNotNull('weight', instance.weight);
  writeNotNull('height', instance.height);
  writeNotNull('age', instance.age);
  writeNotNull('maxHr', instance.maxHr);
  writeNotNull('zone1MinPower', instance.zone1MinPower);
  writeNotNull('zone1MaxPower', instance.zone1MaxPower);
  writeNotNull('zone2MinPower', instance.zone2MinPower);
  writeNotNull('zone2MaxPower', instance.zone2MaxPower);
  writeNotNull('zone3MinPower', instance.zone3MinPower);
  writeNotNull('zone3MaxPower', instance.zone3MaxPower);
  writeNotNull('zone4MinPower', instance.zone4MinPower);
  writeNotNull('zone4MaxPower', instance.zone4MaxPower);
  writeNotNull('zone5MinPower', instance.zone5MinPower);
  writeNotNull('zone5MaxPower', instance.zone5MaxPower);
  return val;
}
