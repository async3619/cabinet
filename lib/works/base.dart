import 'package:cabinet/database/object_box.dart';

abstract class BaseWork {
  final Future<void> Function(ObjectBox objectBox) _callback;

  BaseWork(this._callback);

  Future<void> doWork(ObjectBox objectBox) async {
    await _callback(objectBox);
  }
}
