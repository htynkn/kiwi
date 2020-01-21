import 'package:json_annotation/json_annotation.dart';

part 'comic_book.g.dart';

@JsonSerializable()
class ComicBook {
  String name;
  String url;
  String logo;

  ComicBook();

  Map<String, dynamic> toJson() => _$ComicBookToJson(this);

  factory ComicBook.fromJson(Map<String, dynamic> json) =>
      _$ComicBookFromJson(json);
}
