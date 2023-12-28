import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/works/manager.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';

import 'database/object_box.dart';
import 'objectbox.g.dart';
import 'routes/home/main.dart';

late final ObjectBox objectBox;
late final Admin admin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectBox = await ObjectBox.create();
  WorkManager().initialize(objectBox);

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
