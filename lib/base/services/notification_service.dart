import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio_background/just_audio_background.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_logo');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> initJustAUdioBackgroundNotification()async{
     await JustAudioBackground.init(
    androidNotificationChannelId: 'com.lofiii.lyrilab',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  }

  NotificationDetails notificationDetails() {
    //! Fill in appropriate values for channelId and channelName
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'lofiii_notification', // Change this to a unique value for your app
      'lofiii', // Change this to a unique value for your app
      importance: Importance.max,
      priority: Priority.high,
    );

    return const NotificationDetails(android: androidPlatformChannelSpecifics);
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    await notificationsPlugin.show(
        id, title, body, notificationDetails(), payload: payload);
  }

}
