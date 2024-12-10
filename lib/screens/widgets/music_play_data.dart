import 'package:flutter/material.dart';
import 'package:musik/conts/colors.dart' as color;
import 'package:musik/conts/fonts.dart' as fonts;

class MusicPlayData extends StatelessWidget {
  String title,author;
  MusicPlayData({super.key,required this.title,required this.author});

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Container(
      width: screen.width,
      height: 120,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: fonts.regular(size: 22),
            maxLines: 2,
          ),
          Text(author,style: fonts.regular(color: color.grey,size: 16),)
        ],
      ),
    );
  }
}
