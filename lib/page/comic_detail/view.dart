import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:kiwi/component/loading.dart';
import 'package:kiwi/domain/enum/comic_detail_direction.dart';
import 'package:kiwi/page/comic_detail/action.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'state.dart';

Widget buildView(
    ComicDetailState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
        title: Text(state.sectionName),
        backgroundColor: Theme.of(viewService.context).primaryColor,
      ),
      body: state.loading
          ? Loading.normalLoading(viewService)
          : renderComicDetails(state, viewService, dispatch));
}

renderComicDetails(ComicDetailState state, ViewService viewService, dispatch) {
  var context = viewService.context;
  return SafeArea(
    child: GestureDetector(
      onLongPress: () {
        Alert(
            closeFunction: () {},
            context: context,
            title: "浏览设置",
            content: Column(
              children: <Widget>[
                DropdownButton<String>(
                  value: state.direction.toString(),
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String newValue) {
                    dispatch(
                        ComicDetailActionCreator.changeDirection(newValue));
                    Navigator.pop(context);
                  },
                  items: <String>[
                    ComicDetailDirection.CROSS.toString(),
                    ComicDetailDirection.VERTICAL.toString()
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value == ComicDetailDirection.CROSS.toString()
                          ? "横向"
                          : "纵向"),
                    );
                  }).toList(),
                ),
              ],
            ),
            buttons: [
              DialogButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "确认",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ]).show();
      },
      child: Stack(
        children: <Widget>[
          Container(
              child: state.direction == ComicDetailDirection.CROSS
                  ? renderCrossStyle(dispatch, state)
                  : renderVerticalStyle(dispatch, state)),
          Container(
            child: Align(
              alignment: FractionalOffset.bottomRight,
              child: LayoutBuilder(
                builder: (_, c) {
                  return Text(
                    "${state.currentPageIndex}/${state.pics.length}",
                    style: TextStyle(
                        fontSize: 18,
                        backgroundColor: Colors.black,
                        color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

renderVerticalStyle(dispatch, ComicDetailState state) {
  var scrollController = ScrollController();

  scrollController.addListener(() {
    var pixels = scrollController.position.pixels;
    var maxScrollExtent = scrollController.position.maxScrollExtent;

    int currentPageIndex =
        (pixels / maxScrollExtent * state.pics.length).round();

    if (currentPageIndex != state.currentPageIndex) {
      dispatch(ComicDetailActionCreator.changePageIndex(currentPageIndex));
    }
  });

  return ListView.builder(
      controller: scrollController,
      itemCount: state.pics.length,
      itemBuilder: (context, index) {
        return Image(
            image: AdvancedNetworkImage(state.pics[index], useDiskCache: true));
      });
}

PhotoViewGallery renderCrossStyle(dispatch, ComicDetailState state) {
  return PhotoViewGallery.builder(
    scrollDirection: Axis.horizontal,
    scrollPhysics: const BouncingScrollPhysics(),
    onPageChanged: (index) {
      dispatch(ComicDetailActionCreator.changePageIndex(index));
    },
    builder: (BuildContext context, int index) {
      return PhotoViewGalleryPageOptions(
        imageProvider:
            AdvancedNetworkImage(state.pics[index], useDiskCache: true),
      );
    },
    itemCount: state.pics.length,
  );
}
