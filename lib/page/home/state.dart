import 'package:fish_redux/fish_redux.dart';

class HomePageState implements Cloneable<HomePageState> {
  String name;

  @override
  HomePageState clone() {
    return HomePageState()..name = name;
  }
}

HomePageState initState(Map<String, dynamic> args) {
  final HomePageState state = HomePageState();

  state.name = "我";

  return state;
}
