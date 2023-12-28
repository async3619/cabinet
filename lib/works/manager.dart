import 'dart:convert';

import 'package:cabinet/database/object_box.dart';
import 'package:flutter/foundation.dart';
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
  ];

  void initialize(ObjectBox objectBox) {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

    if (kDebugMode) {
      Workmanager().cancelAll();
    }

    Workmanager().registerPeriodicTask("worker-tasks", "worker-tasks",
        inputData: {
          "reference":
              base64Encode(objectBox.store.reference.buffer.asUint8List()),
        },
        frequency: const Duration(minutes: 15),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ));
  }

  Future<void> start(ObjectBox objectBox) async {
    for (final work in _works) {
      await work.doWork(objectBox);
    }
  }
}
