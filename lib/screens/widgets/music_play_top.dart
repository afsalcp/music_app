import 'package:flutter/material.dart';
import 'package:musik/conts/colors.dart' as color;

class MusicPlayTop extends StatelessWidget {
  const MusicPlayTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
            width: double.infinity,
            height: 50,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
    
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: IconButton(
                      onPressed:()=> Navigator.pop(context),
                      icon: Icon(Icons.chevron_left,color: Colors.white,size: 25,),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(color.shaded_bg),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
    
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.favorite_outline,color: Colors.white,size: 25,),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(color.shaded_bg),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}