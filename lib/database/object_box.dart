import 'package:cabinet/database/image.dart';
import 'package:cabinet/database/post.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:cabinet/objectbox.g.dart';

class ObjectBox {
  late final Store store;

  ObjectBox._create(this.store);

  static Future<ObjectBox> create({ByteData? reference}) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final storeDir = p.join(docsDir.path, 'objectbox');

    Store store;
    if (reference != null) {
      store = Store.fromReference(getObjectBoxModel(), reference);
    } else {
      store = await openStore(
        directory: storeDir,
      );
    }

    if (kDebugMode) {
      store.box<Post>().removeAll();
      store.box<Image>().removeAll();
    }

    return ObjectBox._create(store);
  }
}
