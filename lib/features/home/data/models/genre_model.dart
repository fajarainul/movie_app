import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';

part 'genre_model.g.dart';

@JsonSerializable()
class GenreModel extends Equatable {
  final String? name;
  final int? id;

  const GenreModel({this.name, this.id});

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      _$GenreModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenreModelToJson(this);

  @override
  List<Object?> get props => [name, id];

  Genre toGenre() {
    return Genre(name: name, id: id);
  }
}
