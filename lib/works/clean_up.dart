import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/object_box.dart';
import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/works/base.dart';

class CleanUpWork extends BaseWork {
  CleanUpWork() : super(_doWork);

  static Future<void> _doWork(ObjectBox objectBox, bool isNotificationGranted,
      WorkDataCallback onData) async {
    final repositoryHolder = RepositoryHolder(
        objectBox, ImageBoardApi(baseUrl: 'https://a.4cdn.org'));

    final watchers = await repositoryHolder.watcher.findAll();
    final posts = await repositoryHolder.post.getOpeningPosts();
    final remainingIds = <int>{};

    for (var watcher in watchers) {
      for (var post in posts) {
        final isMatched = watcher.isPostMatch(post);
        if (isMatched) {
          remainingIds.add(post.id);
        }
      }
    }

    final notMatchedPosts =
        posts.where((element) => !remainingIds.contains(element.id)).toList();

    final targetPosts =
        notMatchedPosts.expand((post) => [post, ...post.children]).toList();

    final targetImages = targetPosts.expand((post) => post.images).toList();

    await repositoryHolder.image.bulkDelete(targetImages);
    await repositoryHolder.post.bulkDelete(targetPosts);
  }
}
