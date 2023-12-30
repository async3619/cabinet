import 'package:cabinet/database/blacklist.dart';
import 'package:cabinet/database/repository/base.dart';
import 'package:objectbox/objectbox.dart';

class BlacklistRepository extends BaseRepository {
  BlacklistRepository(Box<Blacklist> box) : super(box);

  Future<void> add(int boardId, int postId) async {
    final blacklist = Blacklist();
    blacklist.boardId = boardId;
    blacklist.postId = postId;

    await box.putAsync(blacklist);
  }
}
