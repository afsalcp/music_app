import 'package:flutter/material.dart';
import 'package:musik/conts/player.dart';
import 'package:musik/screens/play_list.dart';
import 'package:musik/screens/play_music.dart';
import 'package:musik/screens/widgets/column_list.dart';
import 'package:musik/screens/widgets/loading.dart';
import 'package:musik/screens/widgets/scroll_cards.dart' as scroll_card;
import 'package:musik/screens/widgets/scroll_rouded.dart';
import 'package:musik/screens/widgets/sub_playing.dart';
import 'package:musik/screens/widgets/wlcm_wdgt.dart';
import 'package:musik/conts/youtube.dart' as yt;
import 'package:musik/conts/youtube.dart' as youtube;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}) {
    yt.trending().then((value) {
      List<Map> val = [];

      for (var i in value) {
        val.add({
          "title": i.title ?? "No Title",
          "sub_title": i.author ?? "No Author",
          "img": i.thumbnails.length == 0
              ? "https://img.youtube.com/vi/${i.id}/0.jpg"
              : i.thumbnails[0].url.toString(),
          "func": <Widget>() {
            MusicPlayer.setRelated(i);
            return PlayMusic(id: i.id.toString());
          }
        });
      }

      trending.value = val;
    });

    yt.trendingPlayLists().then((value) {
      List<Map> val = [];

      for (var i in value) {
        val.add({
          "title": i.title ?? "No Title",
          "sub_title": "${i.videoCount} Songs",
          "img": i.thumbnails.length == 0
              ? "https://img.youtube.com/vi/${i.id}/0.jpg"
              : i.thumbnails[0].url.toString(),
          "func": <Widget>() {
            return PlayList(
              meta: i,
              id: i.id.toString(),
            );
          }
        });
      }

      playlists.value = val;
    });

    yt.recentTunes().then((value) {
      List<Map> val = [];

      for (var i in value) {
        val.add({
          "title": i.title ?? "No Title",
          "sub_title": i.author ?? "Unknown author",
          "img": (i.thumbnails.length == 0
              ? "https://img.youtube.com/vi/${i.id}/0.jpg"
              : i.thumbnails[0].url.toString()),
          "duration": i.duration,
          "func": <Widget>() {
            MusicPlayer.setRelated(i);
            return PlayMusic(id: i.id.toString());
          }
        });
      }

      recentSongs.value = val;
    });

    
  }

  ValueNotifier<List<Map>?> trending = ValueNotifier(null);
  ValueNotifier<List<Map>?> playlists = ValueNotifier(null),
      recentSongs = ValueNotifier(null);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 26, 28),
      body: Stack(
        children: [
          ListView(
            children: [
              const WelcomeWidget(),
              ValueListenableBuilder(
                  valueListenable: trending,
                  builder: (context, val, _) {
                    return scroll_card.ScrollView(
                        cards: val, title: "Trending Today");
                  }),
              ValueListenableBuilder(
                  valueListenable: playlists,
                  builder: (context, val, _) {
                    return ScrollRounded(
                        cards: val, title: "Trending Play Lists");
                  }),
              ValueListenableBuilder(
                  valueListenable: recentSongs,
                  builder: (context, val, _) {
                    return ColumnList(cards: val, title: "Recent Tunes");
                  }),
            ],
          ),
          SubPlaying()
        ],
      ),
    );
  }
}
