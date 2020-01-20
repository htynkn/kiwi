import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:logger_flutter/logger_flutter.dart';

import 'state.dart';

Widget buildView(
    HomePageState state, Dispatch dispatch, ViewService viewService) {
  var plugins = state.plugins;

  var widgets = <Widget>[];

  for (var plugin in plugins) {
    widgets.add(Container(
      child: Text(plugin.name),
    ));
  }

  return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
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
