import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/object_box.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/database/repository/watcher.dart';
import 'package:cabinet/notifications/manager.dart';
import 'package:cabinet/tasks/watcher.dart';
import 'package:cabinet/works/base.dart';

class WatcherWork extends BaseWork {
  WatcherWork() : super(_doWork);

  static Future<void> _doWork(
      ObjectBox objectBox, bool isNotificationGranted) async {
    final repositoryHolder = RepositoryHolder(
        objectBox, ImageBoardApi(baseUrl: 'https://a.4cdn.org'));

    final watchers = await repositoryHolder.watcher.findAll();

    final notificationId = await NotificationManager().createNotification(
        title: 'Cabinet Watcher',
        body: 'Watcher Work is running',
        locked: true);

    for (final watcher in watchers) {
      if (watcher.status == WatcherStatus.running.index) {
        continue;
      }

      final currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
      final lastRunTimeStamp = watcher.lastRun?.millisecondsSinceEpoch ?? 0;
      final crawlingInterval = (watcher.crawlingInterval ?? 0) * 1000 * 60;
      if (currentTimeStamp - lastRunTimeStamp < crawlingInterval) {
        continue;
      }

      final task = WatcherTask(
        repositoryHolder: repositoryHolder,
        watcher: watcher,
      );

      await NotificationManager().updateNotification(
          id: notificationId,
          title: 'Cabinet Watcher',
          body: "Watcher #${watcher.id} '${watcher.name}' is running",
          locked: true);

      await task.doTask();
    }

    await NotificationManager().dismissNotification(notificationId);
  }
}
