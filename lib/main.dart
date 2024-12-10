import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:musik/conts/notification.dart';
import 'package:musik/conts/player.dart';
import 'package:musik/screens/home_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:musik/screens/play_music.dart';

late AudioService _backActions;

Future<void> main(List<String> args) async {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Music Player',
        channelDescription: 'Music Player Controll',
        playSound: false,
        enableVibration: false,
        importance: NotificationImportance.Low,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      )
    ],
    // debug: true
  );

  AudioService.init(builder: (){
    return AudioHandler2();
  });

  runApp(const MusikApp());
}

class MusikApp extends StatefulWidget {
  const MusikApp({super.key});

  @override
  State<MusikApp> createState() => _MusikAppState();
}

class _MusikAppState extends State<MusikApp> {
  void checkNotificationPermission() {
    AwesomeNotifications().isNotificationAllowed().then((value) {
      if (!value) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationCotroller.onRecivedAction);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkNotificationPermission();

    //initState();
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Regular",
      ),
      home: HomeScreen(),
      builder: EasyLoading.init(),
    );
  }
}
