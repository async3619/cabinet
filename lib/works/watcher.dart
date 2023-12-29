import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/image.dart';
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

    final allImages = List<Image>.empty(growable: true);
    final watchers = await repositoryHolder.watcher.findAll();

    final notificationId = await NotificationManager().createNotification(
        title: "Cabinet Watcher",
        body: "Watcher Work is running",
        locked: true);

    for (final watcher in watchers) {
      if (watcher.status == WatcherStatus.running.index) {
        continue;
      }

      final task = WatcherTask(
        repositoryHolder: repositoryHolder,
        watcher: watcher,
        onImages: (images) {
          allImages.addAll(images);
        },
      );

      await NotificationManager().updateNotification(
          id: notificationId,
          title: "Cabinet Watcher",
          body: "Watcher #${watcher.id} '${watcher.name}' is running",
          locked: true);

      await task.doTask();
    }

    await NotificationManager().dismissNotification(notificationId);

    if (allImages.isNotEmpty) {
      final imageNotificationId = await NotificationManager()
          .createNotification(
              title: "Cabinet Watcher",
              body: "Downloading all ${allImages.length} images...",
              locked: true,
              category: NotificationCategory.Progress,
              progress: 0);

      var index = 0;
      for (final _ in allImages) {
        await NotificationManager().updateNotification(
            id: imageNotificationId,
            title: "Cabinet Watcher",
            body: "Downloading image ${index + 1} of ${allImages.length}...",
            locked: true,
            category: NotificationCategory.Progress,
            layout: NotificationLayout.ProgressBar,
            progress: ((index / allImages.length) * 100).toInt());

        await Future.delayed(const Duration(seconds: 1));

        index++;
      }
    }
  }
}
