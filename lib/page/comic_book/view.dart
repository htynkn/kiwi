import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/component/loading.dart';
import 'package:kiwi/domain/comic_book.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:logger_flutter/logger_flutter.dart';

import 'state.dart';

Widget buildView(
    ComicBookState state, Dispatch dispatch, ViewService viewService) {
  var books = state.comicBooks;

  return Scaffold(
      appBar: AppBar(
        title: Text(state.name),
        backgroundColor: Theme.of(viewService.context).primaryColor,
      ),
      body: state.loading
          ? Loading.normalLoading(viewService)
          : renderComicBooks(books, viewService));
}



Container renderComicBooks(List<ComicBook> books, ViewService viewService) {
  return Container(
    padding: const EdgeInsets.all(2.0),
    child: LogConsoleOnShake(
      child: Center(
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: books.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(viewService.context).primaryColorDark,
                          width: 1.0,
                          style: BorderStyle.solid)),
                  height: 60,
                  child: Row(
                    children: <Widget>[
                      Align(
                        alignment: FractionalOffset.centerLeft,
                        child:
                            Container(child: Image.network(books[index].logo)),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Center(child: Text("${books[index].name}")),
                      ),
                    ],
                  ),
                );
              })),
    ),
  );
}
