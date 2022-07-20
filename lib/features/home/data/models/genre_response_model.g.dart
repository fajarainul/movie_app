// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenreResponseModel _$GenreResponseModelFromJson(Map<String, dynamic> json) =>
    GenreResponseModel(
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GenreResponseModelToJson(GenreResponseModel instance) =>
    <String, dynamic>{
      'genres': instance.genres?.map((e) => e.toJson()).toList(),
    };
