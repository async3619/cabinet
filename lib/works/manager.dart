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

  ObjectBox? _objectBox;

  final _works = <BaseWork>[
    WatcherWork(),
    CleanUpWork(),
    ImageWork(),
  ];

  void initialize(ObjectBox objectBox) {
    _objectBox = objectBox;

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

  void schedule() {
    final box = _objectBox;
    if (box == null) {
      return;
    }

    Workmanager().registerOneOffTask(
        'worker-task-scheduled', 'worker-task-scheduled',
        inputData: {
          'reference': base64Encode(box.store.reference.buffer.asUint8List()),
          'force': true,
        },
        constraints: Constraints(
          networkType: NetworkType.connected,
        ));
  }

  Future<void> start(
      ObjectBox objectBox, bool isNotificationGranted, bool force) async {
    int startedAt = DateTime.now().millisecondsSinceEpoch;
    int totalImageCount = 0;
    int totalPostCount = 0;
    String? errorMessage;

    handleData(int imageCount, int postCount) async {
      totalImageCount += imageCount;
      totalPostCount += postCount;
    }

    handleError(dynamic error) {
      errorMessage = error.toString();
    }

    for (final work in _works) {
      await work.doWork(
          objectBox, isNotificationGranted, force, handleData, handleError);

      if (errorMessage != null) {
        break;
      }
    }

    int finishedAt = DateTime.now().millisecondsSinceEpoch;

    final repositoryHolder = RepositoryHolder(
        objectBox, ImageBoardApi(baseUrl: 'https://a.4cdn.org'));

    int watcherCount = repositoryHolder.watcher.count();

    repositoryHolder.executionLog.create(
        startedAt, finishedAt, totalImageCount, totalPostCount, watcherCount,
        errorMessage: errorMessage);
  }
}
