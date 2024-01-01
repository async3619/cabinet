import 'dart:convert';

import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/object_box.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/works/clean_up.dart';
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
    CleanUpWork(),
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
    int startedAt = DateTime.now().millisecondsSinceEpoch;
    int totalImageCount = 0;
    int totalPostCount = 0;

    handleData(int imageCount, int postCount) async {
      totalImageCount += imageCount;
      totalPostCount += postCount;
    }

    for (final work in _works) {
      await work.doWork(objectBox, isNotificationGranted, handleData);
    }

    int finishedAt = DateTime.now().millisecondsSinceEpoch;

    final repositoryHolder = RepositoryHolder(
        objectBox, ImageBoardApi(baseUrl: 'https://a.4cdn.org'));

    int watcherCount = repositoryHolder.watcher.count();

    repositoryHolder.executionLog.create(
        startedAt, finishedAt, totalImageCount, totalPostCount, watcherCount);
  }
}
