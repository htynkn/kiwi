import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class Loading {
  static normalLoading(ViewService viewService) {
    var theme = Theme.of(viewService.context);
    return Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: LiquidCircularProgressIndicator(
          value: 0.25,
          // Defaults to 0.5.
          valueColor: AlwaysStoppedAnimation(theme.primaryColorLight),
          // Defaults to the current Theme's accentColor.
          backgroundColor: theme.backgroundColor,
          // Defaults to the current Theme's backgroundColor.
          borderColor: theme.primaryColorDark,
          borderWidth: 5.0,
          direction: Axis.horizontal,
          // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
          center: Text("Loading..."),
        ),
      ),
    );
  }
}
