import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/component/loading.dart';
import 'package:kiwi/page/install/action.dart';
import 'package:logger_flutter/logger_flutter.dart';

import 'state.dart';

Widget buildView(
    InstallState state, Dispatch dispatch, ViewService viewService) {
  var plugins = state.pluginsInfo;

  var renderInstallList = Container(
    padding: const EdgeInsets.all(2.0),
    child: LogConsoleOnShake(
      child: Center(
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: plugins.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  key: ValueKey("install_item_$index"),
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(viewService.context).primaryColorDark,
                          width: 1.0,
                          style: BorderStyle.solid)),
                  height: 60,
                  child: Row(
                    children: <Widget>[
                      Container(
                          height: 45,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                  color: Theme.of(viewService.context)
                                      .primaryColorLight,
                                  style: BorderStyle.solid)),
                          width: 45,
                          child: Center(
                            child: Text(
                              "${plugins[index].name.substring(0, 1)}",
                              style: TextStyle(fontSize: 20),
                            ),
                          )),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Center(child: Text("${plugins[index].name}")),
                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.centerRight,
                          child: Container(
                            key: ValueKey("install_item_button_$index"),
                            padding: EdgeInsets.only(right: 10),
                            child: RaisedButton(
                              child: Text("安装"),
                              onPressed: () {
                                dispatch(InstallActionCreator.install({
                                  "remoteUrl": plugins[index].remoteUrl,
                                  "name": plugins[index].name
                                }));
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              })),
    ),
  );

  return Scaffold(
      appBar: AppBar(
        title: const Text('插件安装'),
        backgroundColor: Theme.of(viewService.context).primaryColor,
      ),
      body: state.loading
          ? Loading.normalLoading(viewService)
          : renderInstallList);
}
