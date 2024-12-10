import 'package:flutter/material.dart';

TextStyle regular({Color color=Colors.white,double size=18,FontWeight weight=FontWeight.w100,TextOverflow overflow=TextOverflow.ellipsis}){
  return TextStyle(
    color: color,
    fontWeight: weight,
    fontSize: size,
    fontFamily: "Regular"
  );
}