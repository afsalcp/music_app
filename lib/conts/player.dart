import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musik/conts/notification.dart';
import 'package:musik/conts/youtube.dart' as youtube;
import 'package:musik/screens/widgets/music_settings.dart';
import 'package:musik/screens/widgets/music_slider.dart';
import 'package:musik/screens/widgets/sub_playing.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MusicPlayer {
  static bool _curSts = false;
  static bool plySts = false;

  static AudioPlayer player = AudioPlayer();
  static Video? nextSong,prevSong;
  static String nextSongUrl = "",prevSongUrl="";

  static late String relatedFrom;

  static List<dynamic> relatedSongs = [];

  static bool relatedLoading = false,loadingNext=false;

  static Video? currentSong;

  static bool musicChanging=false;

  static Future<void> play({String? url}) async {

    if(url==null){
      await player.play();
      plySts=true;
      Notification.create();
      MusicSettings.play_pause.value=true;
      SubPlaying.curntlyPaying.value = {"video":currentSong, "sts": true};
      return;
    }
    
    if (_curSts) {
      await player.stop();
    }

    print(url);

    try {
      player.setUrl(url).catchError(()=>null);
      

      player.play();
      plySts = true;
      Notification.create();
      MusicSettings.play_pause.value=true;
      _curSts = true;
      SubPlaying.curntlyPaying.value = {"video":currentSong, "sts": true};
      
    } catch (e) {
      print(e);
      _curSts = false;
      plySts = false;
    }
  }

  static void play_pause() {
    if (plySts) {
      player.pause();
      plySts = false;
      MusicSettings.play_pause.value=false;
      SubPlaying.curntlyPaying.value = {"video":currentSong, "sts": false};
    } else {
      player.play();
      plySts = true;
      MusicSettings.play_pause.value=true;
      SubPlaying.curntlyPaying.value = {"video":currentSong, "sts": true};
    }

    Notification.create();
  }

  static Future<void> pause()async{
    plySts=false;
    await player.pause();
    Notification.create();
    MusicSettings.play_pause.value=false;
    SubPlaying.curntlyPaying.value = {"video":currentSong, "sts": false};
    return;
  }

  static Future<Video?> next() async {
    if(musicChanging)return null;
    try {
      if (relatedLoading || loadingNext) {
        await Future.delayed(const Duration(milliseconds: 500));
        
        print("looped");
        Video? a = await next();
        musicChanging=false;
        SubPlaying.curntlyPaying.value = {"video":currentSong, "sts": true};
        return a;
      }

      if (nextSongUrl == "") return null;
      musicChanging=true;
      player
          .setUrl(nextSongUrl, initialPosition: const Duration(seconds: 0))
          .catchError(() => null);
      player.play();
      MusicSettings.loading.value = false;

      while(nextSong==null){
        await Future.delayed(const Duration(milliseconds: 500));
      }

      loadNext(nextSong!.id.value);

      MusicSlider.slider.value = 0;

      currentSong=nextSong;
      Notification.create();

      musicChanging=false;
      SubPlaying.curntlyPaying.value = {"video":currentSong, "sts": true};

      return nextSong;
    } catch (e) {
      print(e);
      musicChanging=false;
      return null;
    }
  }

  static Future<Video?> prev()async{
    if(musicChanging)return null;
    try {
      if(relatedLoading){
        await Future.delayed(const Duration(milliseconds: 5000));

        Video? a=await prev();
        musicChanging=false;
        SubPlaying.curntlyPaying.value = {"video":currentSong, "sts": true};
        return a;
      }
    
      if(prevSongUrl=="")return null;

      musicChanging=true;

      player.setUrl(prevSongUrl,initialPosition: Duration.zero).catchError(()=>null);
      player.play().catchError(()=>null);

      MusicSettings.loading.value=false;

      loadNext(prevSong!.id.value);

      MusicSlider.slider.value = 0;
      currentSong=prevSong;

      Notification.create();

      musicChanging=false;
      SubPlaying.curntlyPaying.value = {"video":currentSong, "sts": true};

      return prevSong;

    } catch (e) {
      print("hey there error is there");
      print(e);
      musicChanging=true;
      return null;
    }
  }

  static Future<void> setRelated(vid) async {
    try {
      relatedLoading = true;
      print("trying to set related content");
      String title = vid.title;
      title = title.split("|")[0];
      List raw = await youtube.yt.search
          .searchContent("${vid.title} related", filter: TypeFilters.playlist);

          print(raw);

      

      List pllst = await youtube.yt.playlists
          .getVideos(
            raw[0].id,
          )
          .toList();

      relatedSongs = RelatedParent.toSametype(pllst);
      relatedSongs.insert(0, RelatedParent(vid));
      relatedLoading = false;
      relatedSongs = relatedSongs.where((element) {
        int fInd = relatedSongs.indexWhere((elm) => element.id == elm.id, 0);
        int nInd =
            relatedSongs.indexWhere((elm) => element.id == elm.id, fInd + 1);

        if (nInd == -1) return true;
        return false;
      }).toList();

      
    } catch (e) {
      relatedLoading=false;

      print(e);
      print("error there");
      return;
    }
  }

  static void loadNext(String id) async {
    try {
      print("loaidng next song");
       loadingNext=true;
      if (relatedSongs.isEmpty && !relatedLoading) return;
      if (relatedLoading) {
        print("waiting for load");
        Timer(const Duration(milliseconds: 500), () {
          loadNext(id);
        });
        return;
      }

      if (relatedSongs.last.id.toString() == id) {
        Video vid = await youtube.getData(id);

        await setRelated(vid);
      }

      var rl = relatedSongs[
          (relatedSongs.indexWhere((element) => element.id.toString() == id)) +
              1];
      print(
          "${rl.id} $id is is that ${relatedSongs.indexWhere((element) => element.id.toString() == id)}");
      StreamManifest srcs =
          await youtube.yt.videos.streams.getManifest(rl.id.toString());

      nextSongUrl = srcs.audioOnly.withHighestBitrate().url.toString();

      

      if (relatedSongs.first.id.toString() != id) {
        int a=relatedSongs.indexWhere((element) => element.id.toString() == id);
        if(a<=0) {
          a=0;
        } else {
          a=a-1;
        }
        var rl = relatedSongs[a];
              StreamManifest srcs = await youtube.yt.videos.streams.getManifest(rl.id.toString());
        prevSongUrl = srcs.audioOnly.withHighestBitrate().url.toString();

        prevSong = await youtube.yt.videos.get(rl.id.toString());
      }
      nextSong = await youtube.yt.videos.get(rl.id.toString());


      loadingNext=false;

      return;
    } catch (e) {
      loadingNext=false;
      print(e);
      return;
    }
  }
}

class RelatedParent {
  dynamic id;

  RelatedParent(x) {
    id = x.id;
  }

  static List<RelatedParent> toSametype(dynamic x) {
    List<RelatedParent> y = [];
    for (dynamic a in x) {
      y.add(RelatedParent(a));
    }

    return y;
  }
}

class AudioHandler2 extends BaseAudioHandler with QueueHandler{
  @override
  Future<void> play()async{
    print('playing the song');
    await MusicPlayer.play();
  }
  @override
  Future<void> pause()async{
    await MusicPlayer.pause();
  }
}

