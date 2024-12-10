import 'package:flutter/material.dart';
import 'package:musik/conts/colors.dart' as color;
import 'package:musik/conts/fonts.dart' as fonts;
import 'package:musik/conts/player.dart';
import 'package:musik/screens/widgets/music_settings.dart';

class MusicSlider extends StatelessWidget {
  double? width, height;
  double time;
  late String timeStr;
  MusicSlider({super.key, this.width, this.height, required this.time}) {
    int p = time.toInt();

    int hr = p ~/ (60 * 60);
    p -= (hr * 60 * 60).toInt();
    int mt = p ~/ 60;
    p -= mt * 60;

    timeStr =
        "${hr == 0 ? "" : hr > 9 ? hr.toString() : "0${hr.toString()}"}${mt > 9 ? mt.toString() : "0$mt"}:${p > 9 ? p.toInt() : "0${p.toInt()}"}";
  }

  static ValueNotifier<double> slider = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    width ??= screen.width * .8;
    height ??= 8;
    return Column(
      children: [
        GestureDetector(
          onPanStart: (data) {
            double p = data.localPosition.dx / width!;

            if (p < 0) p = 0;
            if (p > 1) p = 1;

            slider.value = p;

            MusicPlayer.pause();
          },
          onPanUpdate: (data) {
            double p = data.localPosition.dx / width!;
            if (p < 0) p = 0;
            if (p > 1) p = 1;
            slider.value = p;
          },
          onPanEnd: (data) async {
            print("pan ended");
            await MusicPlayer.player
                .seek(Duration(seconds: (time * slider.value).toInt()));
            await MusicPlayer.play();
            MusicSettings.play_pause.value = true;

            print('hey there exicutoon snsjh');
          },
          onTapUp: (data) async {
            print("tap ended");
            await MusicPlayer.pause();
            double p = data.localPosition.dx / width!;
            if (p < 0) p = 0;
            if (p > 1) p = 1;
            slider.value = p;

            await MusicPlayer.player
                .seek(Duration(seconds: (time * slider.value).toInt()));
            MusicSettings.play_pause.value = true;
            print("tap ended 12 ");
            MusicPlayer.play();
            print("tap ended  333");
          },
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color.grey, width: 1),
            ),
            child: Container(
              height: height,
              width: width,
              alignment: Alignment.centerLeft,
              child: ValueListenableBuilder(
                valueListenable: slider,
                builder: (context, val, _) {
                  return Container(
                      width: width! * val, height: height, color: color.grey);
                },
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder(
                  valueListenable: slider,
                  builder: (context, val, _) {
                    double p = val * time.toInt();

                    int hr = p ~/ (60 * 60);
                    p -= (hr * 60 * 60).toInt();
                    int mt = p ~/ 60;
                    p -= mt * 60;

                    String t =
                        "${hr == 0 ? "" : hr > 9 ? hr.toString() : "0${hr.toString()}:"}${mt > 9 ? mt.toString() : "0$mt"}:${p > 9 ? p.toInt() : "0${p.toInt()}"}";

                    return Text(
                      t,
                      style: fonts.regular(color: color.grey, size: 16),
                    );
                  }),
              Text(
                timeStr,
                style: fonts.regular(color: color.grey, size: 16),
              )
            ],
          ),
        )
      ],
    );
  }
}
