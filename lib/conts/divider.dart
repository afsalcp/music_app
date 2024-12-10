

import 'package:flutter/material.dart';

List<Widget> divider(List<Widget> x,Widget divide){
  List<Widget> nlist=[];
  for(Widget i in x){
    nlist.addAll([i,divide]);
  }

  return nlist;
}