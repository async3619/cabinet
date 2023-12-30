import 'package:cabinet/database/object_box.dart';

abstract class BaseWork {
  final Future<void> Function(ObjectBox objectBox, bool isNotificationGranted)
      _callback;

  BaseWork(this._callback);

  Future<void> doWork(ObjectBox objectBox, bool isNotificationGranted) async {
    await _callback(objectBox, isNotificationGranted);
  }
}
