import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:musik/conts/divider.dart';
import 'package:musik/conts/fonts.dart' as fonts;
import 'package:musik/screens/widgets/loading.dart';

class ColumnList extends StatelessWidget {
  List<Map>? cards;
  String title;
  /*
    cards :
      title: string
      sub_title : string
      img : url<string>
      duration : string<hr?:min:sec>
      func : navigation callback
  */
  ColumnList({super.key,this.cards, required this.title});

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
          Column(
            children:cards==null?[LoadingWidget(width: double.infinity,height: 200,)]:( divider(
                cards!.map((card) {
                  return InkWell(
                    onTap:(){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return card["func"]();
                    }));
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              image: DecorationImage(
                                  image: NetworkImage(card['img']),
                                  fit: BoxFit.cover)),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: (screen.width - 215),
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  card['title'],
                                  maxLines: 1,
                                  style: fonts.regular(size: 20),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  card["sub_title"],
                                  maxLines: 1,
                                  style: fonts.regular(
                                      size: 16,
                                      color: const Color.fromARGB(255, 115, 118, 130)),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment:Alignment.center,
                                width:60,
                                child: Text(
                                  card["duration"],
                                  style: fonts.regular(
                                      color: const Color.fromARGB(255, 115, 118, 130),
                                      size: 16),
                                ),
                              ),
                              const SizedBox(
                                width:30,
                                child: IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Ionicons.ellipsis_vertical_outline,
                                      color: Color.fromARGB(255, 115, 118, 130),
                                      size: 18,
                                    )),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 10))),
          )
        ],
      ),
    );
  }
}


/*
return  Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: DecorationImage(image: NetworkImage(cards[ind]['img']),fit: BoxFit.cover)
                      ), 
                    )
                  ],
                );
                */