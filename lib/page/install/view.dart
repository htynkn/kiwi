import 'package:kiwi/page/install/action.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:logger_flutter/logger_flutter.dart';

import 'state.dart';

Widget buildView(
    InstallState state, Dispatch dispatch, ViewService viewService) {
  var plugins = state.pluginsInfo;

  return Scaffold(
      appBar: AppBar(
        title: const Text('插件安装'),
      ),
      body: Container(
        padding: const EdgeInsets.all(2.0),
        child: LogConsoleOnShake(
          child: Center(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: plugins.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        dispatch(InstallActionCreator.install({
                          "remoteUrl": plugins[index].remoteUrl,
                          "name": plugins[index].name
                        }));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blue,
                                width: 1.0,
                                style: BorderStyle.solid)),
                        height: 50,
                        child: Center(child: Text("${plugins[index].name}")),
                      ),
                    );
                  })),
        ),
      ));
}
