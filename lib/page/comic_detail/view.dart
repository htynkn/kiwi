import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:kiwi/component/loading.dart';
import 'package:kiwi/page/comic_detail/action.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
  return Stack(
    children: <Widget>[
      Container(
          child: PhotoViewGallery.builder(
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
      )),
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
  );
}
