import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:musik/conts/colors.dart' as color;
import 'package:musik/conts/player.dart';
import 'package:musik/screens/widgets/loading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:musik/conts/youtube.dart' as yt;
import 'package:dio/dio.dart';

Dio dio=Dio();

class MusicSettings extends StatelessWidget {
  MusicSettings({super.key, required this.id, required this.refresh, this.title});

  static ValueNotifier<bool> play_pause = ValueNotifier(true);
  static ValueNotifier<bool> loading=ValueNotifier(false);

  String id;
  var refresh;
  String? title;

  static ValueNotifier<bool> replay=ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    replay.value=false;
    loading.value=false;
    return ValueListenableBuilder(
      valueListenable: loading,
      builder: (context,val,_) {
        if(val)return LoadingWidget();
        return Container(
          height: 100,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: ()async{
                  try {
                    AndroidDeviceInfo deviceInfo=await DeviceInfoPlugin().androidInfo;
                    if(!(await Permission.storage.request().isGranted)||(num.parse(deviceInfo.version.release)>10&&! await Permission.manageExternalStorage.request().isGranted)){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please allow the storage permission for downloading this song")));

                      return;
                    }   

                    EasyLoading.show(status: "Downloading...",);


                    
                    StreamManifest vid = await yt.yt.videos.streams.getManifest(id);

                    AudioOnlyStreamInfo audio=vid.audioOnly.withHighestBitrate();
                    Uri url= audio.url;
                    print("size of the file ${(audio.size.totalKiloBytes*1024).toInt()}");
                    Response res=await dio.get(url.toString(),options: Options(responseType: ResponseType.bytes,headers: {"Range":"bytes=0-${(audio.size.totalKiloBytes*1024).toInt()}"}),onReceiveProgress: (a,b){
                      print("downloading $a $b");
                    });

                    var stream=res.data;

                    Directory? path=Directory("/storage/emulated/0/Download/");

                    print(path.path);
                    
                    
                    if(!File(path.path).existsSync()||!File("${path.path}Musik").existsSync()){
                      await Directory("${path.path}Musik").create(recursive: true);
                    }
                    print("path created, writing to file");

                    File file=File("${path.path}Musik/${title!.substring(0,15).replaceAll(RegExp(r'(-|:|\/|;|\?)'), " ")}.m4a");
                    
                    print("file created successfully");
                    await file.writeAsBytes(stream);

                    
                    print('writing successfully ${file.existsSync()}');
                    EasyLoading.dismiss();
                    

                  } catch (e) {
                    print("downloading error");
                    print(e);
                    EasyLoading.dismiss();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("We can't download the audio file right now")));
                    return;
                  }
                },
                icon: Icon(
                  Icons.arrow_circle_down,
                  color: color.grey,
                  size: 40,
                ),
              ),
              IconButton(
                onPressed: (){
                  loading.value=true;

                  MusicPlayer.pause();

                  MusicPlayer.prev().then((vid) {
                    if(vid!=null)return refresh(vid);
                    loading.value=false;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("We can't find previuos song right now")));
                    MusicPlayer.play();
                    
                  });
                  
                },
                icon: Icon(
                  Ionicons.play_skip_back_circle_outline,
                  color: color.grey,
                  size: 40,
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: play_pause,
                  builder: (context, val, _) {
                    return IconButton(
                      onPressed: () {
                        play_pause.value = !(play_pause.value);
                        MusicPlayer.play_pause();
                      },
                      icon: Icon(
                        val
                            ? Ionicons.pause_circle_outline
                            : Ionicons.play_circle_outline,
                        color: color.grey,
                        size: 80,
                        weight: 100,
                      ),
                    );
                  }),
              IconButton(
                onPressed: () {
                  loading.value=true;
                  MusicPlayer.pause();
                  MusicPlayer.next().then((vid) {
                    if(vid==null){
                      MusicPlayer.play();
                      loading.value=false;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("We can't find next song right now")));
                      return ;
                    }
                    refresh(vid);
                  });
                },
                icon: Icon(
                  Ionicons.play_skip_forward_circle_outline,
                  color: color.grey,
                  size: 40,
                ),
              ),
              ValueListenableBuilder(
                valueListenable: replay,
                builder: (context,val,_) {
                  return IconButton(
                    onPressed: (){
                      replay.value=!replay.value;
                    },
                    icon: Icon(
                      Ionicons.refresh_circle_outline,
                      color: !val?color.grey:const Color.fromARGB(255, 208, 74, 112),
                      size: 40,
                    ),
                  );
                }
              ),
            ],
          ),
        );
      }
    );
  }
}
