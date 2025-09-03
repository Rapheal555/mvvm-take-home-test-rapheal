import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'category.g.dart';

@JsonSerializable()
class CategoryModel extends Equatable {
  final int id;
  final String name;
  final String icon;
  

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
   
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    icon,
    
  ];
}
