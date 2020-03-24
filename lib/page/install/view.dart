import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kiwi/component/loading.dart';
import 'package:kiwi/domain/enum/plugin_provider_type.dart';
import 'package:kiwi/page/install/action.dart';
import 'package:permission_handler/permission_handler.dart';

import 'state.dart';

Widget buildView(
    InstallState state, Dispatch dispatch, ViewService viewService) {
  var plugins = state.pluginsInfo;

  TextEditingController searchInputController =
      new TextEditingController(text: state.searchKey ?? "");

  var renderFileInstallView = Container(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: <Widget>[
        Text(
          "当前插件:" + PluginProviderTypeHelper.getValue(state.providerType),
          style: TextStyle(
              fontSize: 10,
              color: Theme.of(viewService.context).highlightColor),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(viewService.context).primaryColorDark,
                  width: 1.0,
                  style: BorderStyle.solid)),
          margin: EdgeInsets.only(bottom: 8, top: 8),
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 2),
          child: Row(
            children: <Widget>[
              Text("选择文件"),
              Expanded(
                child: SizedBox(),
              ),
              RaisedButton(
                  child: Text("打开"),
                  onPressed: () async {
                    PermissionStatus permission = await PermissionHandler()
                        .checkPermissionStatus(PermissionGroup.storage);

                    if (permission != PermissionStatus.granted) {
                      await PermissionHandler()
                          .requestPermissions([PermissionGroup.storage]);
                    }

                    File file = await FilePicker.getFile(
                        type: FileType.custom, fileExtension: 'xml');

                    if (file != null) {
                      dispatch(InstallActionCreator.install(
                          {"remoteUrl": file.path, "name": ""}));
                    } else {
                      Fluttertoast.showToast(
                          msg: "没有选择文件",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          textColor: Theme.of(viewService.context).errorColor,
                          fontSize: 16.0);
                    }
                  })
            ],
          ),
        ),
      ],
    ),
  );

  var renderRemoteInstallView = Container(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: <Widget>[
        Text(
          "当前插件:" + PluginProviderTypeHelper.getValue(state.providerType),
          style: TextStyle(
              fontSize: 10,
              color: Theme.of(viewService.context).highlightColor),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(viewService.context).primaryColorDark,
                  width: 1.0,
                  style: BorderStyle.solid)),
          margin: EdgeInsets.only(bottom: 8, top: 8),
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 2),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
                    controller: searchInputController,
                    key: ValueKey("install-search-input"),
                    decoration: const InputDecoration(
                      hintText: '插件关键字',
                    )),
              ),
              InkWell(
                key: ValueKey("install-search-button"),
                child: Icon(Icons.search),
                onTap: () {
                  var searchText = searchInputController.text;
                  dispatch(InstallActionCreator.search(searchText));
                },
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: plugins.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  key: ValueKey("install_item_$index"),
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
              }),
        ),
      ],
    ),
  );

  void _select(dynamic c) {
    dispatch(InstallActionCreator.switchProvider(c));
  }

  return Scaffold(
      appBar: AppBar(
        title: const Text('插件安装'),
        backgroundColor: Theme.of(viewService.context).primaryColor,
        actions: <Widget>[
          PopupMenuButton(
            tooltip: "选择插件来源",
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: PluginProviderType.Sited,
                  child: Text(PluginProviderTypeHelper.getValue(
                      PluginProviderType.Sited)),
                ),
                PopupMenuItem(
                  value: PluginProviderType.Ka94,
                  child: Text(PluginProviderTypeHelper.getValue(
                      PluginProviderType.Ka94)),
                ),
                PopupMenuItem(
                  value: PluginProviderType.File,
                  child: Text(PluginProviderTypeHelper.getValue(
                      PluginProviderType.File)),
                )
              ];
            },
          ),
        ],
      ),
      body: state.loading
          ? Loading.normalLoading(viewService)
          : state.providerType == PluginProviderType.File
              ? renderFileInstallView
              : renderRemoteInstallView);
}
