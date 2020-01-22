import 'package:json_annotation/json_annotation.dart';

part 'comic_section_detail.g.dart';

@JsonSerializable()
class ComicSectionDetail {
  String name;
  String url;

  ComicSectionDetail();

  Map<String, dynamic> toJson() => _$ComicSectionDetailToJson(this);

  factory ComicSectionDetail.fromJson(Map<String, dynamic> json) =>
      _$ComicSectionDetailFromJson(json);
}
