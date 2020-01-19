import 'package:json_annotation/json_annotation.dart';

part 'plugin_db_object.g.dart';

@JsonSerializable()
class PluginDbObject {
  String name;
  String description;
  String content;
  String uniqueKey;
  int installTime;

  PluginDbObject();

  Map<String, dynamic> toJson() => _$PluginDbObjectToJson(this);
  factory PluginDbObject.fromJson(Map<String, dynamic> json) =>
      _$PluginDbObjectFromJson(json);
}
