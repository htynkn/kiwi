class RawPluginInfo {
  int version;
  int engineVersion;

  bool private;

  RawPluginMetaInfo meta;

  RawPluginMainInfo main;
}

class RawPluginMetaInfo {
  String ua;

  String title;

  String author;

  String intro;

  String url;

  String expr;

  String logo;

  String encode;
}

class RawPluginMainInfo {
  int dtype;

  RawPluginMainHostInfo home;
}

class RawPluginMainHostInfo {
  String cache;

  String url;

  String parse;

  String method;

  String title;
}
