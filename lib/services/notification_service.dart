import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    final androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosSettings = DarwinInitializationSettings();

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
  }

  Future<void> showMusicNotification({
    required String title,
    required String artist,
    String? album,
    bool isPlaying = true,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'music_player_channel',
      'Music Player',
      channelDescription: 'Music player controls',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      playSound: false,
      showWhen: false,
      enableVibration: false,
      actions: [
        AndroidNotificationAction('previous', 'Previous'),
        AndroidNotificationAction(
          isPlaying ? 'pause' : 'play',
          isPlaying ? 'Pause' : 'Play',
        ),
        AndroidNotificationAction('next', 'Next'),
      ],
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      0,
      title,
      artist + (album != null ? ' • $album' : ''),
      notificationDetails,
    );
  }

  Future<void> cancelNotification() async {
    await _notifications.cancel(0);
  }
}