import 'package:flutter/material.dart';
import 'package:musik/conts/fonts.dart' as fonts;
import 'package:musik/screens/widgets/loading.dart';

class ScrollRounded extends StatelessWidget {
  List<Map>? cards;
  String title;

  ScrollRounded({super.key, this.cards, required this.title});

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: fonts.regular(size: 22),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: screen.width,
            height: 120,
            child:cards==null?LoadingWidget(width: screen.width,):ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, ind) {
                return InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return cards![ind]["func"]();
                    }));
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                                image: NetworkImage(cards![ind]['img']),
                                fit: BoxFit.cover)),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          cards![ind]['title'],
                          style: fonts.regular(size: 15,color: Colors.grey),
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                );
              },
              itemCount: cards!.length,
              separatorBuilder: (ctx, ind) => const SizedBox(
                width: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
