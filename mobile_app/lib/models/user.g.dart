// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BVUser _$BVUserFromJson(Map<String, dynamic> json) => BVUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      deleted: json['deleted'] as bool?,
      isAdmin: json['isAdmin'] as bool?,
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
  return val;
}
