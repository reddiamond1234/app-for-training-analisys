// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'item_property.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class BVUser extends ItemProperty {
  const BVUser({
    required String id,
    required this.email,
    required super.name,
    this.deleted,
    this.isAdmin,
  }) : super(id: id);

  final String email;
  final bool? deleted;
  final bool? isAdmin;

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
  }) {
    return BVUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      deleted: deleted ?? this.deleted,
    );
  }
}
