import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'article.g.dart';

@JsonSerializable()
class Article extends Equatable {
  final int id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final Author author;
  final Category category;
  final Series series;

  const Article({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.author,
    required this.category,
    required this.series,
  });

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    imageUrl,
    createdAt,
    author,
    category,
    series,
  ];
}

@JsonSerializable()
class Author extends Equatable {
  final int id;
  final String name;

  const Author({required this.id, required this.name});

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorToJson(this);

  @override
  List<Object?> get props => [id, name];
}

@JsonSerializable()
class Category extends Equatable {
  final int id;
  final String name;
  final String icon;

  const Category({required this.id, required this.name, required this.icon});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  List<Object?> get props => [id, name, icon];
}

@JsonSerializable()
class Series extends Equatable {
  final int id;
  final String name;

  const Series({required this.id, required this.name});

  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesToJson(this);

  @override
  List<Object?> get props => [id, name];
}
