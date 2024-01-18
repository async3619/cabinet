import 'dart:io';

import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/object_box.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/notifications/manager.dart';
import 'package:cabinet/system/file.dart';
import 'package:cabinet/works/base.dart';
import 'package:p_limit/p_limit.dart';

class ImageWork extends BaseWork {
  ImageWork() : super(_doWork);

  static Future<void> _doWork(ObjectBox objectBox, bool isNotificationGranted,
      bool force, WorkDataCallback onData, ErrorCallback onError) async {
    final repositoryHolder = RepositoryHolder(
        objectBox, ImageBoardApi(baseUrl: 'https://a.4cdn.org'));

    var allImages = await repositoryHolder.image.findAll();
    allImages = allImages.where((element) => element.path == null).toList();

    if (allImages.isNotEmpty) {
      var remaining = allImages.length;
      final imageNotificationId = await NotificationManager()
          .createNotification(
              title: 'Cabinet Watcher',
              body: 'Downloading $remaining images...',
              locked: true);

      final coreCount = Platform.numberOfProcessors;
      final limit = PLimit<void>(coreCount);
      final input = allImages.map((image) => limit(() async {
            final oldImage = await repositoryHolder.image.findById(image.id);
            if (oldImage == null) return;

            image = await FileSystem().saveImage(image);
            await repositoryHolder.image.save(image);

            remaining--;
            await NotificationManager().updateNotification(
              id: imageNotificationId,
              title: 'Cabinet Watcher',
              body: 'Downloading $remaining images...',
              locked: true,
            );
          }));

      await Future.wait(input);

      await NotificationManager().dismissNotification(imageNotificationId);
    }
  }
}
