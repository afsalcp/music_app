import 'package:flutter/material.dart';
import 'package:musik/conts/colors.dart';
import 'package:musik/conts/fonts.dart';
import 'package:musik/conts/player.dart';
import 'package:musik/conts/youtube.dart' as youtube;
import 'package:musik/screens/play_music.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SubPlaying extends StatelessWidget {
  SubPlaying({super.key}){
    if (MusicPlayer.currentSong == null) {
      SharedPreferences.getInstance().then((SharedPreferences prefs) {
        String? id = prefs.getString("old_played_id");
        if(id==null)return;
        youtube.getData(id).then((Video vid) {
          
          MusicPlayer.currentSong = vid;
          MusicPlayer.setRelated(vid);

          curntlyPaying.value = {
            "video": MusicPlayer.currentSong,
            "state": MusicPlayer.plySts
          };
        });
      });
    } else {
      curntlyPaying.value = {
        "video": MusicPlayer.currentSong,
        "state": MusicPlayer.plySts
      };
    }
  }


  static ValueNotifier<Map?> curntlyPaying = ValueNotifier(null);
  ValueNotifier<bool> ply_sts=ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return ValueListenableBuilder(
      valueListenable: curntlyPaying,
      builder: (context,val,_) {
        if(val==null) return const SizedBox();
        return Positioned(
          bottom: 10,
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return PlayMusic(id: MusicPlayer.currentSong!.id.value);
              }));
            },
            child: Container(
              width: screen.width,
              alignment: Alignment.center,
              child: Container(
                width: screen.width * .8,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: bg,
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 5,
                          offset: Offset(0, 0),
                          spreadRadius: 3,
                          color: Color.fromARGB(163, 45, 63, 84))
                    ],
                    image: DecorationImage(
                        image: NetworkImage(
                          val["video"].thumbnails.maxResUrl
                            ),
                        fit: BoxFit.cover)),
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed:(){
                              Map oldVal=curntlyPaying.value!;
                              curntlyPaying.value=null;
                              MusicPlayer.prev().then((value){ 
                                if(value==null)curntlyPaying.value=oldVal;
                                
                              });
                            },
                            icon: const Icon(
                              Icons.skip_previous_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(81, 12, 14, 41))),
                          ),
                          IconButton(
                            onPressed: (){
                              MusicPlayer.play_pause();
                              ply_sts.value=!ply_sts.value;
                            },
                            icon: Icon(
                              MusicPlayer.plySts? Icons.pause_circle_outline:Icons.play_circle_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(81, 12, 14, 41))),
                          ),
                          IconButton(
                            onPressed: (){
                              Map oldVal=curntlyPaying.value!;
                              curntlyPaying.value=null;
                              MusicPlayer.next().then((value){ 
                                if(value==null)curntlyPaying.value=oldVal;
                                
                              });
                            },
                            icon: const Icon(
                              Icons.skip_next_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(81, 12, 14, 41))),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(81, 12, 14, 41),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Text(
                          val['video'].title.toString().substring(0,20),
                          style: regular(size: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
