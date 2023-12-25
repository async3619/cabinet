import 'package:cabinet/database/image.dart';
import 'package:cabinet/objectbox.g.dart';

class ImageRepository {
  final Box<Image> box;

  ImageRepository(this.box);

  Future<List<Image>> getAll() {
    return box.getAllAsync();
  }

  Future<void> delete(Image image) async {
    await box.removeAsync(image.id);
  }

  Future<void> bulkDelete(List<Image> images) async {
    await box.removeManyAsync(images.map((e) => e.id).toList());
  }
}
