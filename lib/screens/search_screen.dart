import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musik/conts/colors.dart';
import 'package:musik/conts/fonts.dart';
import 'package:musik/conts/player.dart';
import 'package:musik/conts/youtube.dart';
import 'package:musik/screens/play_music.dart';
import 'package:musik/screens/widgets/column_list.dart';
import 'package:musik/screens/widgets/loading.dart';
import 'package:musik/screens/widgets/sub_playing.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'play_list.dart' as pllst;

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  Timer? timer;

  ValueNotifier<List<Map>?> rslts = ValueNotifier([]);
  ValueNotifier<String> mode = ValueNotifier("songs");
  TextEditingController srchTxt = TextEditingController(text: "");

  void searchContent(String query) async {
    if (mode.value == "songs") {
      List res =
          await yt.search.searchContent(query, filter: TypeFilters.video);

      List<Map> val = [];
      for (var vid in res) {
        val.add({
          "title": vid.title,
          "sub_title": vid.author ?? "not defined",
          "img": vid.thumbnails.length == 0
              ? "https://img.youtube.com/vi/${vid.id}/0.jpg"
              : vid.thumbnails[0].url.toString(),
          "func": () {
            MusicPlayer.setRelated(vid);
            return PlayMusic(id: vid.id.toString());
          },
          "duration": vid.duration
        });
      }
      print(val);
      rslts.value = val;
      return;
    }
    List res =
        await yt.search.searchContent(query, filter: TypeFilters.playlist);
    List<Map> val = [];
    for (var vid in res) {
      val.add({
        "title": vid.title,
        "sub_title": "${vid.videoCount} songs",
        "img": vid.thumbnails.length == 0
            ? "https://img.youtube.com/vi/${vid.id}/0.jpg"
            : vid.thumbnails[0].url.toString(),
        "func": () {
          //MusicPlayer.setRelated(vid);
          return pllst.PlayList(
            meta: vid,
            id: vid.id.toString(),
          );
        },
        "duration": ""
      });
    }
    rslts.value = val;
    return;
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: screen.width * .8,
                    height: 50,
                    child: TextField(
                      controller: srchTxt,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        alignLabelWithHint: false,
                        labelText: "Type here to search...",
                        labelStyle: TextStyle(color: grey),
                        border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: grey)),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 80, 198, 244)),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      textAlignVertical: TextAlignVertical.top,
                      onChanged: (txt) {
                        rslts.value = null;
                        if (timer != null) timer!.cancel();
                        timer = Timer(const Duration(seconds: 1), () {
                          searchContent(txt);
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: screen.width,
                  height: 40,
                  child: ValueListenableBuilder(
                      valueListenable: mode,
                      builder: (context, val, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 70,
                              child: TextButton(
                                onPressed: () {
                                  mode.value = "songs";
                                  srchTxt.text = "";
                                },
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: grey, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    minimumSize: const MaterialStatePropertyAll(
                                        Size.zero),
                                    padding: const MaterialStatePropertyAll(
                                        EdgeInsets.all(5)),
                                    backgroundColor: MaterialStatePropertyAll(
                                        val == "songs"
                                            ? grey
                                            : Colors.transparent)),
                                child: Text(
                                  "songs",
                                  style: regular(size: 14),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 70,
                              child: TextButton(
                                onPressed: () {
                                  mode.value = "playlist";
                                  srchTxt.text = "";
                                },
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: grey, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    minimumSize: const MaterialStatePropertyAll(
                                        Size.zero),
                                    padding: const MaterialStatePropertyAll(
                                        EdgeInsets.all(5)),
                                    backgroundColor: MaterialStatePropertyAll(
                                        val == "playlist"
                                            ? grey
                                            : Colors.transparent)),
                                child: Text(
                                  "playlist",
                                  style: regular(size: 14),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        );
                      }),
                ),
                ValueListenableBuilder(
                    valueListenable: rslts,
                    builder: (context, val, _) {
                      return Container(
                        child: val == null
                            ? LoadingWidget(
                                height: screen.height - 150,
                              )
                            : (val.isEmpty
                                ? const BeforeSearch()
                                : ColumnList(
                                    title: "Results for your query",
                                    cards: rslts.value,
                                  )),
                      );
                    })
              ],
            ),
            SubPlaying()
          ],
        ),
      ),
    );
  }
}

class BeforeSearch extends StatelessWidget {
  const BeforeSearch({super.key});

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Container(
      width: screen.width * .9,
      height: screen.height - 150,
      decoration: const BoxDecoration(
          image:
              DecorationImage(image: AssetImage("assets/imgs/srch_img.png"))),
    );
  }
}
