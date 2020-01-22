import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/component/loading.dart';
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
  return Container(
      child: PhotoViewGallery.builder(
    scrollPhysics: const BouncingScrollPhysics(),
    builder: (BuildContext context, int index) {
      return PhotoViewGalleryPageOptions(
        imageProvider: NetworkImage(state.pics[index]),
      );
    },
    itemCount: state.pics.length,
  ));
}
