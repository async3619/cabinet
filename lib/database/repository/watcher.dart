import 'package:cabinet/database/board.dart';
import 'package:cabinet/database/filter.dart';
import 'package:cabinet/database/watcher.dart';
import 'package:cabinet/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';

enum WatcherStatus {
  idle,
  running,
}

class WatcherRepository extends BaseRepository<Watcher> {
  WatcherRepository(Box<Watcher> box) : super(box);

  Future<Watcher> create(String name, List<Board> boards, List<Filter> filters,
      int crawlingInterval, bool archived) async {
    final entity = Watcher();
    entity.name = name;
    entity.boards.addAll(boards);
    entity.filters.addAll(filters);
    entity.currentStatus = WatcherStatus.idle;
    entity.crawlingInterval = crawlingInterval;
    entity.archived = archived;

    box.put(entity);

    return entity;
  }

  Future<Watcher> update(int id,
      {String? name,
      List<Board>? boards,
      List<Filter>? filters,
      int? crawlingInterval,
      bool? archived}) async {
    final entity = box.get(id);
    if (entity == null) {
      throw Exception('Watcher with id $id not found');
    }

    if (name != null) {
      entity.name = name;
    }

    if (crawlingInterval != null) {
      entity.crawlingInterval = crawlingInterval;
    }

    if (archived != null) {
      entity.archived = archived;
    }

    if (boards != null) {
      entity.boards.clear();
      entity.boards.addAll(boards);
    }

    if (filters != null) {
      entity.filters.clear();
      entity.filters.addAll(filters);
    }

    box.put(entity);
    return entity;
  }

  Future<int> setWatcherStatus(Watcher watcher, WatcherStatus status) {
    watcher.currentStatus = status;

    if (status == WatcherStatus.running) {
      watcher.lastRun = DateTime.now();
    }

    return box.putAsync(watcher);
  }
}
