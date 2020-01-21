// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComicBook _$ComicBookFromJson(Map<String, dynamic> json) {
  return ComicBook()
    ..name = json['name'] as String
    ..url = json['url'] as String
    ..logo = json['logo'] as String;
}

Map<String, dynamic> _$ComicBookToJson(ComicBook instance) => <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'logo': instance.logo,
    };
