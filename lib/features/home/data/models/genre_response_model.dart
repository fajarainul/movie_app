import 'package:json_annotation/json_annotation.dart';
import 'package:movie_app/core/data/models/base_response_model.dart';
import 'package:movie_app/features/home/data/models/genre_model.dart';

part 'genre_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GenreResponseModel extends BaseResponseModel {
  const GenreResponseModel({this.genres = const []}):super();

  @JsonKey(name: "genres")
  final List<GenreModel>? genres;

  factory GenreResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GenreResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenreResponseModelToJson(this);
}
