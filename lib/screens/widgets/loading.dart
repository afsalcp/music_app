import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  double? width, height;
  LoadingWidget({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    width ??= 50;
    height ??= 50;

    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: LoadingAnimationWidget.stretchedDots(
        color: Color.fromARGB(255, 152, 169, 190),
        size: 50,
      ),
    );
  }
}
