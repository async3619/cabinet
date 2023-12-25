import 'package:cabinet/database/image.dart';
import 'package:cabinet/objectbox.g.dart';

import 'base.dart';

class ImageRepository extends BaseRepository<Image> {
  ImageRepository(Box<Image> box) : super(box);
}
