import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/image.dart';
import 'package:cabinet/database/object_box.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/database/repository/watcher.dart';
import 'package:cabinet/tasks/watcher.dart';
import 'package:cabinet/works/base.dart';

class WatcherWork extends BaseWork {
  WatcherWork() : super(_doWork);

  static Future<void> _doWork(ObjectBox objectBox) async {
    final repositoryHolder = RepositoryHolder(
        objectBox, ImageBoardApi(baseUrl: 'https://a.4cdn.org'));

    final allImages = List<Image>.empty(growable: true);
    final watchers = await repositoryHolder.watcher.findAll();
    for (final watcher in watchers) {
      if (watcher.status == WatcherStatus.running) {
        continue;
      }

      final task = WatcherTask(
        repositoryHolder: repositoryHolder,
        watcher: watcher,
        onImages: (images) {
          allImages.addAll(images);
        },
      );

      await task.doTask();
    }
  }
}
