import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kiwi/component/loading.dart';
import 'package:kiwi/domain/comic_book.dart';
import 'package:kiwi/page/comic_book/action.dart';
import 'package:logger_flutter/logger_flutter.dart';

import 'state.dart';

final ratio = 3 / 5;

Widget buildView(
    ComicBookState state, Dispatch dispatch, ViewService viewService) {
  var books = state.comicBooks;
  var theme = Theme.of(viewService.context);

  return Scaffold(
      appBar: AppBar(
        title: Text(state.name),
        backgroundColor: theme.primaryColor,
      ),
      body: state.loading
          ? Loading.normalLoading(viewService)
          : renderComicBooks(state, books, theme, viewService, dispatch));
}

Container renderComicBooks(ComicBookState state, List<ComicBook> books,
    ThemeData theme, ViewService viewService, Dispatch dispatch) {
  List<Widget> widgets = List();

  for (var book in books) {
    widgets.add(InkWell(
      splashColor: theme.primaryColor,
      onTap: () {
        dispatch(ComicBookActionCreator.jumpToSection(
            state.pluginId, book.url, book.logo));
      },
      child: Center(
          child: Column(
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Center(
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: TransitionToImage(
                      image:
                          AdvancedNetworkImage(book.logo, useDiskCache: true),
                      width: constraints.maxWidth - 30,
                      height: constraints.maxWidth / ratio - 60,
                      placeholder: CircularProgressIndicator()),
                ),
              );
            },
          ),
          SizedBox(
            height: 3,
          ),
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              width: constraints.maxWidth - 30,
              child: Center(
                child: Text(
                  book.name,
                  style: TextStyle(fontSize: 18),
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            );
          })
        ],
      )),
    ));
  }

  return Container(
    padding: const EdgeInsets.all(2.0),
    child: LogConsoleOnShake(
      child: Center(
          child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: ratio,
        children: widgets,
      )),
    ),
  );
}
