import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:kiwi/core/logging_service.dart';
import 'package:kiwi/core/plugin_manager.dart';
import 'package:kiwi/domain/dao/plugin_db_object.dart';
import 'package:kiwi/domain/enum/plugin_type.dart';
import 'package:kiwi/domain/plugin.dart';
import 'package:kiwi/domain/plugin_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/strings.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DefaultPluginManager extends PluginManager {
  String rootFolderPath;
  LoggingService logging;

  DefaultPluginManager(this.logging, {String path}) {
    if (isNotEmpty(path)) {
      this.rootFolderPath = path;
    }
  }

  Future<Database> openDB() async {
    DatabaseFactory dbFactory = databaseFactoryIo;

    if (isEmpty(this.rootFolderPath)) {
      var directory = await getApplicationDocumentsDirectory();
      this.rootFolderPath = directory.path;
    }
    return dbFactory.openDatabase(this.rootFolderPath + "/default.db");
  }

  @override
  Future<int> install(PluginInfo info, String xmlContent) async {
    var db = await openDB();

    var uniqueKey = md5.convert(utf8.encode(xmlContent)).toString();

    var store = intMapStoreFactory.store('plugins');

    var finder = Finder(filter: Filter.equals('uniqueKey', uniqueKey));
    var existingPlugin = await store.findFirst(db, finder: finder);

    if (existingPlugin != null && existingPlugin.key > 0) {
      return Future.value(existingPlugin.key);
    }

    var pluginDbObject = PluginDbObject();

    pluginDbObject.name = info.name;
    pluginDbObject.description = info.description;
    pluginDbObject.content = xmlContent;
    pluginDbObject.uniqueKey = uniqueKey;
    pluginDbObject.installTime = new DateTime.now().millisecondsSinceEpoch;

    var key = await store.add(db, pluginDbObject.toJson());

    logging.debug("new installed plugin id $key");
    return Future.value(key);
  }

  @override
  load() async {
    var db = await openDB();
    var store = intMapStoreFactory.store('plugins');

    var result = await store.find(db);
    logging.debug("load plugins from db as $result");

    List<Plugin> plugins = List();

    for (var item in result) {
      var pluginDbObject = PluginDbObject.fromJson(item.value);

      var plugin = Plugin(item.key, pluginDbObject.name);

      plugins.add(plugin);
    }

    return Future.value(plugins);
  }

  @override
  Future<void> refresh() {
    return null;
  }

  @override
  getById(int id) async {
    var db = await openDB();

    var store = intMapStoreFactory.store('plugins');
    var result = await store.findFirst(db,
        finder: Finder(filter: Filter.equals(Field.key, id)));

    var pluginDbObject = PluginDbObject.fromJson(result.value);

    var plugin = Plugin(result.key, pluginDbObject.name);
    plugin.pluginType = PluginType.COMIC;
    plugin.content = pluginDbObject.content;

    return plugin;
  }
}
