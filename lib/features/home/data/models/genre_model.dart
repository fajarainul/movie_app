import 'package:movie_app/features/home/domain/entities/genre.dart';

class GenreModel extends Genre{

  const GenreModel({name, id}) : super(name: name, id: id);


  factory GenreModel.fromJson(Map<String, dynamic> data) => GenreModel(
    name: data['name'] as String?,
    id: data['id'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'name' : name,
    'id'  : id
  };

}