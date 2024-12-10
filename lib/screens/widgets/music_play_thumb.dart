import 'package:flutter/material.dart';
import 'package:musik/conts/colors.dart' as color;

class MusicPlayThumb extends StatelessWidget {
  String thumb;
  MusicPlayThumb({super.key,required this.thumb});

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    print(screen);

    return Container(
      width: double.infinity,
      height: screen.height*.4,
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(top: 80),
      child: Container(
        width: screen.width<screen.height?screen.width*.8:screen.height*.8,
        height: screen.width<screen.height?screen.width*.8:screen.height*.8,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(thumb),fit: BoxFit.cover,onError:(_,$){
            print("error");
          } ),
          borderRadius: BorderRadius.circular(10)
        ),
      ),
    );
  }
}
