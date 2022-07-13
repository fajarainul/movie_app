import 'dart:convert';

import 'package:equatable/equatable.dart';

class Genre extends Equatable {
  final int? id;
  final String? name;

  const Genre({this.id, this.name});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];
}
