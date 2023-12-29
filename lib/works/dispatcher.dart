import 'dart:convert';
import 'dart:typed_data';

import 'package:cabinet/database/object_box.dart';
import 'package:cabinet/notifications/manager.dart';
import 'package:cabinet/works/manager.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final isNotificationGranted =
        await NotificationManager().isNotificationAllowed();

    final rawReference = inputData!['reference'];
    if (rawReference == null) {
      return Future.value(false);
    }

    final reference =
        ByteData.view(Uint8List.fromList(base64Decode(rawReference)).buffer);
    final objectBox = await ObjectBox.create(reference: reference);

    await WorkManager().start(objectBox, isNotificationGranted);

    return Future.value(true);
  });
}
