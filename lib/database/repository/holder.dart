import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/archived_post.dart';
import 'package:cabinet/database/blacklist.dart';
import 'package:cabinet/database/board.dart';
import 'package:cabinet/database/execution_log.dart';
import 'package:cabinet/database/image.dart';
import 'package:cabinet/database/object_box.dart';
import 'package:cabinet/database/post.dart';
import 'package:cabinet/database/repository/blacklist.dart';
import 'package:cabinet/database/repository/board.dart';
import 'package:cabinet/database/repository/execution_log.dart';
import 'package:cabinet/database/repository/image.dart';
import 'package:cabinet/database/repository/post.dart';
import 'package:cabinet/database/repository/watcher.dart';
import 'package:cabinet/database/watcher.dart';

class RepositoryHolder {
  late final BoardRepository board;
  late final WatcherRepository watcher;
  late final PostRepository post;
  late final ImageRepository image;
  late final BlacklistRepository blacklist;
  late final ExecutionLogRepository executionLog;
  late final ObjectBox objectBox;

  RepositoryHolder(
    this.objectBox,
    ImageBoardApi imageBoardApi,
  ) {
    board = BoardRepository(imageBoardApi, objectBox.store.box<Board>());
    watcher = WatcherRepository(objectBox.store.box<Watcher>());
    post = PostRepository(imageBoardApi, objectBox.store.box<Post>(),
        archivedPostBox: objectBox.store.box<ArchivedPost>());
    image = ImageRepository(objectBox.store.box<Image>());
    blacklist = BlacklistRepository(objectBox.store.box<Blacklist>());
    executionLog = ExecutionLogRepository(objectBox.store.box<ExecutionLog>());
  }
}
