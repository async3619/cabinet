import 'dart:convert';

import 'package:cabinet/database/object_box.dart';
import 'package:cabinet/works/image.dart';
import 'package:workmanager/workmanager.dart';

import 'base.dart';
import 'dispatcher.dart';
import 'watcher.dart';

class WorkManager {
  static final WorkManager _instance = WorkManager._internal();

  factory WorkManager() {
    return _instance;
  }

  WorkManager._internal();

  final _works = <BaseWork>[
    WatcherWork(),
    ImageWork(),
  ];

  void initialize(ObjectBox objectBox) {
    Workmanager().initialize(callbackDispatcher);
    Workmanager().cancelAll();

    Workmanager().registerPeriodicTask('worker-tasks', 'worker-tasks',
        inputData: {
          'reference':
              base64Encode(objectBox.store.reference.buffer.asUint8List()),
        },
        frequency: const Duration(minutes: 15),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ));
  }

  Future<void> start(ObjectBox objectBox, bool isNotificationGranted) async {
    for (final work in _works) {
      await work.doWork(objectBox, isNotificationGranted);
    }
  }
}
