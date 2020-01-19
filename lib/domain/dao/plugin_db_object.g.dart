// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_db_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PluginDbObject _$PluginDbObjectFromJson(Map<String, dynamic> json) {
  return PluginDbObject()
    ..name = json['name'] as String
    ..description = json['description'] as String
    ..content = json['content'] as String
    ..uniqueKey = json['uniqueKey'] as String
    ..installTime = json['installTime'] as int;
}

Map<String, dynamic> _$PluginDbObjectToJson(PluginDbObject instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'content': instance.content,
      'uniqueKey': instance.uniqueKey,
      'installTime': instance.installTime,
    };
