import 'package:cabinet/database/board.dart';
import 'package:cabinet/database/filter.dart';
import 'package:cabinet/database/watcher.dart';
import 'package:cabinet/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

class WatcherRepository {
  final Box<Watcher> _box;

  WatcherRepository(this._box);

  Future<Watcher> create(
      String name, List<Board> boards, List<Filter> filters) async {
    final entity = Watcher();
    entity.name = name;
    entity.boards.addAll(boards);
    entity.filters.addAll(filters);

    _box.put(entity);

    return entity;
  }

  Stream<Query<Watcher>> watch() => _box.query().watch();

  Future<List<Watcher>> getAll() => _box.getAllAsync();

  Future<bool> delete(Watcher watcher) => _box.removeAsync(watcher.id);
}
