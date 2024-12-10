import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musik/conts/colors.dart' as color;
import 'package:musik/conts/fonts.dart';
import 'package:musik/conts/player.dart';
import 'package:musik/conts/youtube.dart' as youtube;
import 'package:musik/screens/widgets/loading.dart';
import 'package:musik/screens/widgets/music_play_data.dart';
import 'package:musik/screens/widgets/music_play_thumb.dart';
import 'package:musik/screens/widgets/music_play_top.dart';
import 'package:musik/screens/widgets/music_settings.dart';
import 'package:musik/screens/widgets/music_slider.dart';
import 'package:musik/screens/widgets/sub_playing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PlayMusic extends StatelessWidget {
  String id;
  PlayMusic({super.key, required this.id}) {
    print("its there $id ${MusicPlayer.currentSong?.id}");
    if (id == MusicPlayer.currentSong?.id.toString()) {
      data.value = MusicPlayer.currentSong;
      return;
    }

    data.value = null;
    youtube.getData(id).then((value) {
      data.value = value;
      MusicPlayer.currentSong = data.value;
      youtube.yt.videos.streamsClient.getManifest(id).then((value) {
        MusicPlayer.play(
            url: value.audioOnly.withHighestBitrate().url.toString());
        
      });
    });
  }

  static ValueNotifier<Video?> data = ValueNotifier(null);

  static bool eventSetted = false;

  void playerEvents() {
    if (eventSetted) return;

    eventSetted = true;

    MusicPlayer.player.positionStream.listen((event) {
      if (PlayMusic.data.value == null) return;

      MusicSlider.slider.value =
          event.inSeconds / PlayMusic.data.value!.duration!.inSeconds;
    });
    MusicPlayer.player.playerStateStream.listen((data) {
      if (data.processingState != ProcessingState.completed) return;
      if (MusicSettings.replay.value) {
        print('ended: replaying song');
        MusicPlayer.player.seek(Duration.zero);
        return;
      }
      print("ended: next song loading"); 
      MusicPlayer.next().then((value) {
        
        MusicPlayer.player.play();
        PlayMusic.data.value = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: color.bg,
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: data,
            builder: (context, data, _) {
              MusicPlayer.loadNext(id);

              if (data == null) {
                return LoadingWidget(
                  width: screen.width,
                  height: screen.height,
                );
              }

              playerEvents();

              return Container(
                margin: const EdgeInsets.only(top: 10),
                child: ListView(
                  children: [
                    SizedBox(
                      width: screen.width,
                      height: 50,
                      child: Stack(
                        children: [
                          Positioned(
                            width: screen.width,
                            height: 50,
                            child: const MusicPlayTop(),
                          ),
                        ],
                      ),
                    ),
                    MusicPlayThumb(thumb: data.thumbnails.highResUrl),
                    MusicPlayData(
                      title: data.title,
                      author: data.author,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      child: MusicSlider(
                        time: data.duration!.inSeconds.toDouble(),
                      ),
                    ),
                    MusicSettings(
                        id: data.id.value,
                        refresh: (Video n) {
                          MusicPlayer.player.play();
                          id = n.id.toString();
                          PlayMusic.data.value = n;
                        },
                        title: data.title),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                          child: IconButton(
                              onPressed: null,
                              icon: Icon(
                                Ionicons.chevron_up,
                                color: Colors.white,
                                size: 30,
                              )),
                        ),
                        Text(
                          "Lyrics",
                          style: regular(color: color.grey),
                        )
                      ],
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
