import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/board.dart';
import 'package:cabinet/database/object_box.dart';
import 'package:cabinet/database/repository/board.dart';
import 'package:cabinet/database/repository/watcher.dart';
import 'package:cabinet/database/watcher.dart';

class RepositoryHolder {
  late final BoardRepository board;
  late final WatcherRepository watcher;

  RepositoryHolder(
    ObjectBox objectBox,
    ImageBoardApi imageBoardApi,
  ) {
    board = BoardRepository(imageBoardApi, objectBox.store.box<Board>());
    watcher = WatcherRepository(objectBox.store.box<Watcher>());
  }
}
