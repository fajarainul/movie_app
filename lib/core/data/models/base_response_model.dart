// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class BaseResponseModel extends Equatable {
  const BaseResponseModel({
    this.page,
    this.totalPages,
    this.totalResults,
  });

  @JsonKey(name: "page")
  final int? page;

  @JsonKey(name: "total_pages")
  final int? totalPages;

  @JsonKey(name: "total_results")
  final int? totalResults;

  @override
  List<Object?> get props => [page, totalPages, totalResults];
}
