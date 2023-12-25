import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/board.dart';
import 'package:cabinet/objectbox.g.dart';

import 'base.dart';

class BoardRepository extends BaseRepository<Board> {
  final ImageBoardApi _api;

  BoardRepository(this._api, Box<Board> box) : super(box);

  Future<List<Board>> getBoards() async {
    final count = box.count();
    if (count > 0) {
      return box.getAll();
    }

    var rawBoards = await _api.getBoards();
    var boards = rawBoards.map((board) {
      final entity = Board();
      entity.code = board.id;
      entity.title = board.title;
      entity.description = board.description;

      return entity;
    }).toList();

    box.putMany(boards);
    return boards;
  }
}
