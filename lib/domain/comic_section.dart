import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'comic_section_detail.dart';

part 'comic_section.g.dart';

@JsonSerializable()
class ComicSection {
  String name;
  String author;
  String intro;
  String logo;
  int isSectionsAsc;
  String pluginName;
  List<ComicSectionDetail> sections;

  ComicSection();

  Map<String, dynamic> toJson() => _$ComicSectionToJson(this);

  factory ComicSection.fromJson(Map<String, dynamic> json) =>
      _$ComicSectionFromJson(json);

  static fromJsonString(String jsonString) {
    Map<String, dynamic> map = json.decode(jsonString);

    var comicSection = ComicSection.fromJson(map);

    return comicSection;
  }
}
