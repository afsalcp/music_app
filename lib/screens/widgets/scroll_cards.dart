import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:musik/conts/fonts.dart' as fonts;
import 'package:musik/screens/play_music.dart';
import 'package:musik/screens/widgets/loading.dart';

class ScrollView extends StatelessWidget {
  List<Map>? cards;
  String title;
  ScrollView({super.key,this.cards, required this.title});

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: fonts.regular(size: 22)),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: screen.width,
            height: 180,
            child:cards==null?LoadingWidget(width: screen.width,height: 180,): ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cards!.length,
              itemBuilder: (context,ind){
                return InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return cards![ind]["func"]();
                    }));
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(cards![ind]["img"]),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: 35,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(199, 147, 148, 154),
                              borderRadius: BorderRadius.circular(45)),
                          child: Icon(
                            Ionicons.play,
                            size: 23,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      SizedBox(
                        width: 100,
                        child: Text(
                          cards![ind]["title"],
                          style: fonts.regular(size: 16),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          cards![ind]["sub_title"],
                          style: fonts.regular(size: 14,color: Color.fromARGB(255, 115, 121, 125)),
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context,ind){
                return SizedBox(width: 10,);
              },
            ),
          ),
        ],
      ),
    );
  }
}
