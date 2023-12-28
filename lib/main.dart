import 'dart:convert';
import 'dart:typed_data';

import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'database/object_box.dart';
import 'objectbox.g.dart';
import 'routes/home/main.dart';
import 'tasks/watcher.dart';

late final ObjectBox objectBox;
late final Admin admin;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final rawReference = inputData!['reference'];
    if (rawReference == null) {
      return Future.value(false);
    }

    final reference =
        ByteData.view(Uint8List.fromList(base64Decode(rawReference)).buffer);
    objectBox = await ObjectBox.create(reference: reference);

    final repositoryHolder = RepositoryHolder(
        objectBox, ImageBoardApi(baseUrl: 'https://a.4cdn.org'));

    final watchers = await repositoryHolder.watcher.findAll();
    for (var watcher in watchers) {
      final task = WatcherTask(
        repositoryHolder: repositoryHolder,
        watcher: watcher,
      );

      await task.run();
    }

    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectBox = await ObjectBox.create();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerOneOffTask("task-identifier", "simpleTask", inputData: {
    "reference": base64Encode(objectBox.store.reference.buffer.asUint8List()),
  });

  if (Admin.isAvailable()) {
    admin = Admin(objectBox.store);
  }

  runApp(Provider(
    create: (_) => RepositoryHolder(
        objectBox, ImageBoardApi(baseUrl: 'https://a.4cdn.org')),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cabinet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
        useMaterial3: false,
      ),
      home: const HomeRoute(),
    );
  }
}
