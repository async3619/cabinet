import 'package:cabinet/api/image_board/api.dart';
import 'package:cabinet/database/board.dart';
import 'package:cabinet/objectbox.g.dart';

class BoardRepository {
  final ImageBoardApi _api;
  final Box<Board> _box;

  BoardRepository(this._api, this._box);

  Future<List<Board>> getBoards() async {
    final count = _box.count();
    if (count > 0) {
      return _box.getAll();
    }

    var rawBoards = await _api.getBoards();
    var boards = rawBoards.map((board) {
      final entity = Board();
      entity.code = board.id;
      entity.title = board.title;
      entity.description = board.description;

      return entity;
    }).toList();

    _box.putMany(boards);
    return boards;
  }
}
