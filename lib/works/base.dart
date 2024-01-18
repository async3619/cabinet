import 'package:cabinet/database/object_box.dart';

typedef WorkDataCallback = Future<void> Function(int imageCount, int postCount);

typedef ErrorCallback = void Function(dynamic error);

typedef WorkCallback = Future<void> Function(
    ObjectBox objectBox,
    bool isNotificationGranted,
    bool force,
    WorkDataCallback onData,
    ErrorCallback onError);

abstract class BaseWork {
  final WorkCallback _callback;

  BaseWork(this._callback);

  Future<void> doWork(ObjectBox objectBox, bool isNotificationGranted,
      bool force, WorkDataCallback onData, ErrorCallback onError) async {
    await _callback(objectBox, isNotificationGranted, force, onData, onError);
  }
}
