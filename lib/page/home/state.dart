import 'package:duoduo_cat/domain/plugin.dart';
import 'package:fish_redux/fish_redux.dart';

class HomePageState implements Cloneable<HomePageState> {
  List<Plugin> plugins;

  @override
  HomePageState clone() {
    return HomePageState()..plugins = plugins;
  }
}

HomePageState initState(Map<String, dynamic> args) {
  final HomePageState state = HomePageState();

  state.plugins = List();

  return state;
}
