import 'dart:io';

import 'package:cabinet/database/image.dart';
import 'package:cabinet/objectbox.g.dart';

import 'base.dart';

class ImageRepository extends BaseRepository<Image> {
  ImageRepository(Box<Image> box) : super(box);

  Future<List<Image>> findAllFavorites() async {
    final query = box.query(Image_.isFavorite.equals(true)).build();
    final images = await query.findAsync();
    query.close();

    return images;
  }

  @override
  Future<void> bulkDelete(List<Image> images) async {
    for (final image in images) {
      if (image.path == null) continue;
      if (image.thumbnailPath == null) continue;

      final imageFile = File(image.path!);
      final thumbnailFile = File(image.thumbnailPath!);

      if (await imageFile.exists()) {
        await imageFile.delete();
      }

      if (await thumbnailFile.exists()) {
        await thumbnailFile.delete();
      }
    }

    return super.bulkDelete(images);
  }
}
