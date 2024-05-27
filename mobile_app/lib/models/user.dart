// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'item_property.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class BVUser extends ItemProperty {
  const BVUser({
    required super.id,
    required this.email,
    required super.name,
    this.deleted,
    this.isAdmin,
    this.weight,
    this.height,
    this.age,
    this.maxHr,
    this.zone1MinPower,
    this.zone1MaxPower,
    this.zone2MinPower,
    this.zone2MaxPower,
    this.zone3MinPower,
    this.zone3MaxPower,
    this.zone4MinPower,
    this.zone4MaxPower,
    this.zone5MinPower,
    this.zone5MaxPower,
  });

  final String email;
  final bool? deleted;
  final bool? isAdmin;
  final num? weight;
  final num? height;
  final num? age;
  final num? maxHr;
  final num? zone1MinPower;
  final num? zone1MaxPower;
  final num? zone2MinPower;
  final num? zone2MaxPower;
  final num? zone3MinPower;
  final num? zone3MaxPower;
  final num? zone4MinPower;
  final num? zone4MaxPower;
  final num? zone5MinPower;
  final num? zone5MaxPower;

  factory BVUser.fromJson(Map<String, dynamic> json) => _$BVUserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BVUserToJson(this);

  @override
  List<Object?> get props => [id];

  @override
  String toString() => name ?? "Neznano";

  BVUser copyWith({
    String? id,
    String? email,
    String? name,
    bool? deleted,
    num? weight,
    num? height,
    num? age,
    num? maxHr,
    num? zone1MinPower,
    num? zone1MaxPower,
    num? zone2MinPower,
    num? zone2MaxPower,
    num? zone3MinPower,
    num? zone3MaxPower,
    num? zone4MinPower,
    num? zone4MaxPower,
    num? zone5MinPower,
    num? zone5MaxPower,
  }) {
    return BVUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      deleted: deleted ?? this.deleted,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      maxHr: maxHr ?? this.maxHr,
      zone1MinPower: zone1MinPower ?? this.zone1MinPower,
      zone1MaxPower: zone1MaxPower ?? this.zone1MaxPower,
      zone2MinPower: zone2MinPower ?? this.zone2MinPower,
      zone2MaxPower: zone2MaxPower ?? this.zone2MaxPower,
      zone3MinPower: zone3MinPower ?? this.zone3MinPower,
      zone3MaxPower: zone3MaxPower ?? this.zone3MaxPower,
      zone4MinPower: zone4MinPower ?? this.zone4MinPower,
      zone4MaxPower: zone4MaxPower ?? this.zone4MaxPower,
      zone5MinPower: zone5MinPower ?? this.zone5MinPower,
      zone5MaxPower: zone5MaxPower ?? this.zone5MaxPower,
    );
  }
}
