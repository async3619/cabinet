import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationManager {
  static final NotificationManager _notificationManager =
      NotificationManager._internal();

  factory NotificationManager() {
    return _notificationManager;
  }

  NotificationManager._internal();

  int _notificationId = 0;

  Future<void> initialize() async {
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelKey: 'watcher_channel',
              channelName: 'Watcher notifications',
              channelDescription: 'Show notifications about watcher tasks',
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.white)
        ],
        debug: true);
  }

  Future<bool> ensurePermission() async {
    var granted = await AwesomeNotifications().isNotificationAllowed();
    if (granted) {
      return granted;
    }

    granted =
        await AwesomeNotifications().requestPermissionToSendNotifications();

    return granted;
  }

  Future<bool> isNotificationAllowed() async {
    return await AwesomeNotifications().isNotificationAllowed();
  }

  Future<int> createNotification({
    required String title,
    required String body,
    NotificationCategory? category,
    NotificationLayout? layout,
    int progress = 0,
    bool locked = false,
  }) async {
    _notificationId++;

    final succeeded = await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: _notificationId,
      channelKey: 'watcher_channel',
      title: title,
      body: body,
      locked: locked,
      category: category,
      progress: progress,
      notificationLayout: layout ?? NotificationLayout.Default,
    ));

    if (!succeeded) {
      throw Exception('Failed to create notification');
    }

    return _notificationId;
  }

  Future<void> updateNotification({
    required int id,
    required String title,
    required String body,
    NotificationCategory? category,
    NotificationLayout? layout,
    int progress = 0,
    bool locked = false,
  }) async {
    final succeeded = await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: id,
      channelKey: 'watcher_channel',
      title: title,
      body: body,
      locked: locked,
      category: category,
      progress: progress,
      notificationLayout: layout ?? NotificationLayout.Default,
    ));

    if (!succeeded) {
      throw Exception('Failed to create notification');
    }
  }

  Future<void> dismissNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}
