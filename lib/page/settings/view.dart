import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/domain/constant/settings_key.dart';
import 'package:kiwi/domain/enum/js_engine_type.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';

import 'state.dart';

Widget buildView(
    SettingsState state, Dispatch dispatch, ViewService viewService) {
  return SettingsScreen(title: "应用设置", children: [
    SettingsTileGroup(
      title: "高级设置",
      children: <Widget>[
        RadioPickerSettingsTile(
            settingKey: SettingsKey.JS_ENGINE,
            title: 'Javascript解析器',
            defaultKey: JsEngineType.V8.toString(),
            values: {
              JsEngineType.V8.toString(): 'V8',
              JsEngineType.Rhino.toString(): 'Rhino'
            })
      ],
    ),
  ]);
}
//      body: CardSettings(children: <Widget>[
//        CardSettingsHeader(label: '高级设置'),
//        CardSettingsListPicker(
//          label: "Js引擎",
//          options: <String>[
//            "V8引擎",
//            "Rhino引擎",
//          ],
//          values: <String>[
//            JsEngineType.V8.toString(),
//            JsEngineType.Rhino.toString()
//          ],
//          initialValue: jsEngineValue,
//          onChanged: (value) {
//            dispatch(SettingsActionCreator.onEngineChange(value));
//          },
//        ),
//        CardSettingsButton(label: "保存")
//      ])
