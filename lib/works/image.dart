import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/object_box.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/notifications/manager.dart';
import 'package:cabinet/system/file.dart';
import 'package:cabinet/works/base.dart';

class ImageWork extends BaseWork {
  ImageWork() : super(_doWork);

  static Future<void> _doWork(
      ObjectBox objectBox, bool isNotificationGranted) async {
    final repositoryHolder = RepositoryHolder(
        objectBox, ImageBoardApi(baseUrl: 'https://a.4cdn.org'));

    var allImages = await repositoryHolder.image.findAll();
    allImages = allImages.where((element) => element.path == null).toList();

    if (allImages.isNotEmpty) {
      final imageNotificationId = await NotificationManager()
          .createNotification(
              title: 'Cabinet Watcher',
              body: 'Downloading all ${allImages.length} images...',
              locked: true,
              category: NotificationCategory.Progress,
              progress: 0);

      var index = 0;
      for (var image in allImages) {
        await NotificationManager().updateNotification(
            id: imageNotificationId,
            title: 'Cabinet Watcher',
            body: 'Downloading image ${index + 1} of ${allImages.length}...',
            locked: true,
            category: NotificationCategory.Progress,
            layout: NotificationLayout.ProgressBar,
            progress: ((index / allImages.length) * 100).toInt());

        final oldImage = await repositoryHolder.image.findById(image.id);
        if (oldImage == null) continue;

        image = await FileSystem().saveImage(image);
        await repositoryHolder.image.save(image);

        index++;
      }

      await NotificationManager().dismissNotification(imageNotificationId);
    }
  }
}
