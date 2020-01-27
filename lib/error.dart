import 'package:dio/dio.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

commonErrorHandler(e, Context<dynamic> ctx) {
  if (e is PlatformException || e is DioError) {
    Fluttertoast.showToast(
        msg: "加载出错，即将退回上一页",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        textColor: Theme.of(ctx.context).errorColor,
        fontSize: 16.0);
    Future.delayed(Duration(seconds: 1)).then((value) {
      Navigator.of(ctx.context).pop();
    });
  }
}
