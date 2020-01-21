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
    widgets.add(pluginItemContainer(viewService.context, plugin, dispatch));
  }

  widgets.add(GestureDetector(
    onTap: () {
      dispatch(HomeActionCreator.jumpToInstall());
    },
    child: Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
              color: Theme.of(viewService.context).primaryColorDark,
              width: 1.0,
              style: BorderStyle.solid)),
      child: Container(
          child: Icon(
        Icons.add,
        color: Theme.of(viewService.context).primaryColorDark,
        size: 30,
        semanticLabel: 'click to install new plugin',
      )),
    ),
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

Widget pluginItemContainer(
    BuildContext context, Plugin plugin, Dispatch dispatch) {
  return LayoutBuilder(builder: (context, constraints) {
    return InkWell(
      onTap: () {
        dispatch(HomeActionCreator.clickBook(plugin.id));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
                color: Theme.of(context).primaryColorDark,
                width: 1.0,
                style: BorderStyle.solid)),
        child: Container(
            width: constraints.maxWidth - 10,
            height: constraints.maxHeight - 10,
            child: Center(
              child: Container(
                  padding: EdgeInsets.only(left: 5), child: Text(plugin.name)),
            )),
      ),
    );
  });
}
