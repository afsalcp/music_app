import 'package:audio_service/audio_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:musik/conts/player.dart';
import 'package:musik/screens/play_music.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Notification {
  static AwesomeNotifications notify = AwesomeNotifications();
  static void create() async {
    Video? vid = MusicPlayer.currentSong;

    print("new notification created $vid");

    if (vid == null) return;

    await notify.createNotification(
        content: NotificationContent(
          id: 5,
          channelKey: 'basic_channel',
          title: vid.title,
          notificationLayout: NotificationLayout.MediaPlayer,
          largeIcon: "asset://assets/imgs/music.jpg",
          locked: MusicPlayer.plySts,
          actionType: ActionType.KeepOnTop
        ),
        actionButtons: [
          NotificationActionButton(
              key: "prev",
              label: "prev",
              icon: "resource://drawable/prev",
              showInCompactView: true,
              actionType: ActionType.KeepOnTop,
              autoDismissible: false),
          NotificationActionButton(
              key: MusicPlayer.plySts ? "pause" : "play",
              label: "play",
              icon:
                  "resource://drawable/${MusicPlayer.plySts ? "pause" : "play"}",
              showInCompactView: true,
              actionType: ActionType.KeepOnTop,
              autoDismissible: false),
          NotificationActionButton(
              key: "next",
              label: "next",
              icon: "resource://drawable/next",
              showInCompactView: true,
              actionType: ActionType.KeepOnTop,
              autoDismissible: false),
        ]);
  }
}

class NotificationCotroller {
  @pragma("vm:entry-point")
  static Future<void> onRecivedAction(ReceivedAction a) async {
    if (a.buttonKeyPressed == "play") {
      await MusicPlayer.play();
    } else if (a.buttonKeyPressed == "pause")
      await MusicPlayer.pause();
    else if (a.buttonKeyPressed == "next")
      await MusicPlayer.next();
    else if (a.buttonKeyPressed == "prev")
      await MusicPlayer.prev();
    else
      return;
    PlayMusic.data.value = MusicPlayer.currentSong;
  }
}

class BackgroundController extends BaseAudioHandler with SeekHandler{
  @override
  Future<void> play() async{
    MusicPlayer.play();
  }
  @override
  Future<void> pause() {
    return MusicPlayer.pause();
  }

  @override
  Future<void> fastForward() {
    return MusicPlayer.next();
  }

  @override
  Future<void> rewind() {
    return MusicPlayer.prev();
  }
}


