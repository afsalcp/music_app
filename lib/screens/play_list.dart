import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:musik/conts/colors.dart';
import 'package:musik/conts/player.dart';
import 'package:musik/conts/youtube.dart';
import 'package:musik/screens/play_music.dart';
import 'package:musik/screens/widgets/column_list.dart';
import 'package:musik/screens/widgets/loading.dart';
import 'package:musik/screens/widgets/sub_playing.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PlayList extends StatelessWidget {
  String id;
  SearchPlaylist meta;
  PlayList({super.key, required this.meta, required this.id}) {
    print('loading data');
    Stream<Video> plData = yt.playlists.getVideos(id).take(meta.videoCount);

    plData.forEach((vid) {
      String dur = "";
      if (vid.duration != null) {
        dur =
            "${vid.duration!.inHours != 0 ? "${vid.duration!.inHours}:" : ""}${vid.duration!.inMinutes != 0 ? vid.duration!.inMinutes % 60 : "00"}:${vid.duration!.inSeconds % 60}";
      }
      playlist.value ??= [];
      Map vidData = {
        'title': vid.title,
        'sub_title': vid.author,
        'img': vid.thumbnails.mediumResUrl,
        'duration': dur,
        'func': <Widget>() {
          return PlayMusic(id: vid.id.toString());
        }
      };
      playlist.value = [...playlist.value!, vidData];
      MusicPlayer.relatedSongs = [...MusicPlayer.relatedSongs, vid];
    });
  }

  ValueNotifier<List<Map>?> playlist = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                  height: 250,
                  width: screen.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              NetworkImage(meta.thumbnails.last.url.toString()),
                          fit: BoxFit.cover)),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: screen.width * .8,
                    height: 55,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: trans_bg,
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const IconButton(
                            onPressed: null,
                            icon: Icon(
                              Ionicons.heart_outline,
                              color: Color.fromARGB(255, 218, 52, 52),
                              size: 28,
                            )),
                        IconButton(
                            onPressed: () {
                              MusicPlayer.relatedSongs.shuffle();
                              playlist.value = [];
                              for (var vid in MusicPlayer.relatedSongs) {
                                String dur = "";
                                if (vid.duration != null) {
                                  dur =
                                      "${vid.duration!.inHours != 0 ? "${vid.duration!.inHours}:" : ""}${vid.duration!.inMinutes != 0 ? vid.duration!.inMinutes % 60 : "00"}:${vid.duration!.inSeconds % 60}";
                                }
                                playlist.value = [
                                  ...playlist.value!,
                                  {
                                    'title': vid.title,
                                    'sub_title': vid.author,
                                    'img': vid.thumbnails.mediumResUrl,
                                    'duration': dur,
                                    'func': <Widget>() {
                                      return PlayMusic(id: vid.id.toString());
                                    }
                                  }
                                ];
                              }
                            },
                            icon: const Icon(
                              Ionicons.shuffle,
                              color: Color.fromARGB(255, 6, 194, 69),
                              size: 28,
                            )),
                        IconButton(
                          onPressed: null,
                          iconSize: 40,
                          icon: Icon(
                            Icons.play_circle,
                            color: grey,
                          ),
                        )
                      ],
                    ),
                  )),
              ValueListenableBuilder(
                  valueListenable: playlist,
                  builder: (context, list, _) {
                    return playlist.value == null
                        ? LoadingWidget(
                            height: screen.height - 250,
                          )
                        : ColumnList(
                            title: "",
                            cards: list,
                          );
                  })
            ],
          ),
          SubPlaying()
        ],
      ),
    );
  }
}
