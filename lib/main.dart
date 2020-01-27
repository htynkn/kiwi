import 'package:flutter/material.dart' hide Action;

import 'app.dart';
import 'ioc_configuration.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  IocConfiguration().configDependencies();

  runApp(createApp());
}
