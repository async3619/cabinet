import 'package:cabinet/database/base.dart';
import 'package:objectbox/objectbox.dart';

class BaseRepository<TEntity extends BaseEntity> {
  final Box<TEntity> box;

  BaseRepository(this.box);

  Stream<Query<TEntity>> watch([Condition<TEntity>? qc]) =>
      box.query(qc).watch(triggerImmediately: true);

  Future<List<TEntity>> findAll() {
    return box.getAllAsync();
  }

  Future<List<TEntity?>> findByIds(List<int> ids) {
    return box.getManyAsync(ids);
  }

  Future<TEntity?> findById(int id) {
    return box.getAsync(id);
  }

  int count() {
    return box.count();
  }

  Future<TEntity> save(TEntity entity) async {
    if (entity.id == 0) {
      entity.id = await box.putAsync(entity);
    } else {
      await box.putAsync(entity);
    }

    return entity;
  }

  Future<List<TEntity>> saveAll(List<TEntity> entities) async {
    final ids = await box.putManyAsync(entities);
    for (var i = 0; i < entities.length; i++) {
      entities[i].id = ids[i];
    }

    return entities;
  }

  Future<void> delete(TEntity image) async {
    await box.removeAsync(image.id);
  }

  Future<void> bulkDelete(List<TEntity> images) async {
    await box.removeManyAsync(images.map((e) => e.id).toList());
  }
}
