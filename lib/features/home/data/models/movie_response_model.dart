import 'package:json_annotation/json_annotation.dart';
import 'package:movie_app/core/data/models/base_response_model.dart';
import 'package:movie_app/features/home/data/models/movie_model.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

part 'movie_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieResponseModel extends BaseResponseModel {
  const MovieResponseModel(
      {this.results = const [], page, totalPages, totalResults})
      : super(page: page, totalPages: totalPages, totalResults: totalResults);

  @JsonKey(name: "results")
  final List<MovieModel>? results;

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieResponseModelToJson(this);
}
