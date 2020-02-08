import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:kiwi/component/loading.dart';
import 'package:kiwi/page/comic_section/action.dart';

import 'state.dart';

Widget buildView(
    ComicSectionState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
        title: Text(state.name),
        backgroundColor: Theme.of(viewService.context).primaryColor,
      ),
      body: state.loading
          ? Loading.normalLoading(viewService)
          : renderComicSections(state, viewService, dispatch));
}

renderComicSections(
    ComicSectionState state, ViewService viewService, dispatch) {
  var theme = Theme.of(viewService.context);

  return Center(
    child: Container(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: <Widget>[
                  TransitionToImage(
                      image:
                          AdvancedNetworkImage(state.logo, useDiskCache: true),
                      height: 120,
                      placeholder: CircularProgressIndicator()),
                  Expanded(
                    child: Container(
                      alignment: FractionalOffset.topCenter,
                      child: Column(
                        children: <Widget>[
                          Text(
                            state.name,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "[ by ${state.pluginName} ]",
                            style: TextStyle(fontSize: 14),
                          ),
                          LayoutBuilder(
                            builder: (_, c) {
                              return Container(
                                width: c.maxWidth / 3 * 2,
                                margin: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: Theme.of(viewService.context)
                                            .primaryColorDark,
                                        width: 1.0,
                                        style: BorderStyle.solid)),
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        dispatch(ComicSectionActionCreator
                                            .changeOrder());
                                      },
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        color: Theme.of(viewService.context)
                                            .primaryColorDark,
                                        size: 30,
                                        semanticLabel:
                                            'change order for sections',
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.sections.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      splashColor: theme.primaryColorLight,
                      key: ValueKey("comic_section_item_$index}"),
                      onTap: () {
                        dispatch(ComicSectionActionCreator.jumpToDetail(
                            state.pluginId,
                            state.sections[index].url,
                            state.sections[index].name));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(viewService.context)
                                    .primaryColorDark,
                                width: 1.0,
                                style: BorderStyle.solid)),
                        height: 40,
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Center(
                                  child: Text("${state.sections[index].name}")),
                            ),
                            Expanded(
                              child: Align(
                                alignment: FractionalOffset.centerRight,
                                child: InkWell(
                                  splashColor: theme.primaryColorLight,
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(viewService.context)
                                              .primaryColorDark,
                                          width: 1.0,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    width: 30,
                                    height: 30,
                                    key: ValueKey(
                                        "comic_section_item_download_$index}"),
                                    child: Icon(
                                      Icons.file_download,
                                      color: Theme.of(viewService.context)
                                          .primaryColorDark,
                                      size: 20,
                                      semanticLabel: 'click to download',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    ),
  );
}
