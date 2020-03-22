class RawPluginInfo {
  int version;
  int engineVersion;

  bool private;

  RawPluginMetaInfo meta;

  RawPluginMainInfo main;

  RawPluginScriptInfo script;
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

  RawPluginMainBookInfo book;

  RawPluginMainTagsInfo tags;

  RawPluginMainSectionInfo section;
}

class RawPluginMainTagsInfo {
  String title;

  List<RawPluginMainHostInfo> tags;

  List<RawPluginMainTagInfo> items;
}

class RawPluginMainTagInfo {
  String title;
  String url;
}

class RawPluginMainSectionInfo {
  String cache;

  String parse;

  String method;

  String parseUrl;
}

class RawPluginMainBookInfo {
  String cache;

  String parse;

  String method;

  String title;

  String buildUrl;

  RawPluginMainSectionsInfo sections;
}

class RawPluginMainSectionsInfo {
  String buildUrl;
  String parseUrl;
  String parse;
}

class RawPluginMainHostInfo {
  String cache;

  String url;

  String parse;

  String method;

  String title;
}

class RawPluginScriptInfo {
  List<String> requireList;
  String code;
}
