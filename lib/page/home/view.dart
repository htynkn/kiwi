import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:logger_flutter/logger_flutter.dart';

import '../../domain/plugin.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    HomePageState state, Dispatch dispatch, ViewService viewService) {
  var plugins = state.plugins;

  var widgets = <Widget>[];

  for (var plugin in plugins) {
    widgets.add(pluginItemContainer(viewService.context, plugin));
  }

  widgets.add(GestureDetector(
    onTap: () {
      dispatch(HomeActionCreator.jumpToInstall());
    },
    child: Center(
        child: Icon(
      Icons.add,
      color: Colors.pink,
      size: 24.0,
      semanticLabel: 'click to install new plugin',
    )),
  ));

  return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        backgroundColor: Theme.of(viewService.context).primaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: LogConsoleOnShake(
          child: Center(
              child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            children: widgets,
          )),
        ),
      ));
}

Widget pluginItemContainer(BuildContext context, Plugin plugin) {
  return LayoutBuilder(builder: (context, constraints) {
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
              color: Colors.blue, width: 1.0, style: BorderStyle.solid)),
      child: Row(
        children: <Widget>[
          Center(
            child: SizedBox(
                width: constraints.maxWidth - 10, child: Text(plugin.name)),
          ),
        ],
      ),
    );
  });
}
