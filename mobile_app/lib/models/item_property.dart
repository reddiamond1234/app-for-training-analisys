import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_property.g.dart';

@JsonSerializable()
class ItemProperty extends Equatable {
  @JsonKey(includeToJson: false)
  final dynamic id;
  final String? name;

  const ItemProperty({
    required this.id,
    this.name,
  });

  static toNull(_) => null;

  factory ItemProperty.fromJson(Map<String, dynamic> json) =>
      _$ItemPropertyFromJson(json);

  Map<String, dynamic> toJson() => _$ItemPropertyToJson(this);

  @override
  List<Object?> get props => [id, name];

  @override
  String toString() => name ?? '';
}

abstract class ItemPropertyJsonKeys {
  static const number = 'number';
  static const name = 'name';
}
