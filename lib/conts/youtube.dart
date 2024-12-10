
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final YoutubeExplode yt=YoutubeExplode();


Future<List> trending()async{
  List rslt=await yt.search.searchContent("trending today songs",filter: TypeFilters.video);

  print(rslt);
  rslt= rslt.where((vid){
    print(vid.duration.runtimeType);
    return true;
  }).toList();

  print(rslt[0].id);

  return rslt;
}

Future<List> trendingPlayLists()async{
  List rslt=await yt.search.searchContent("Trending Play Lists",filter: TypeFilters.playlist);

  return rslt;
}


Future<List> recentTunes()async{
  List rslt=await yt.search.searchContent("Recently Released Songs",filter: TypeFilters.video);

  return rslt;
}

Future<Video> getData(id)async{
  Video rslt=await yt.videos.get(id);

  return rslt;
}

