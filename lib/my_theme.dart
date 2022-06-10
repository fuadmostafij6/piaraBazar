import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MyTheme{
  /*configurable colors stars*/
  static Color accent_color = HexColor("#fd7e14");
  static Color soft_accent_color = HexColor("#fd7e14");
  static Color splash_screen_color = HexColor("#fd7e14"); // if not sure , use the same color as accent color
  /*configurable colors ends*/


  /*If you are not a developer, do not change the bottom colors*/
  static Color white = Color.fromRGBO(255,255,255, 1);
  static Color light_grey = Color.fromRGBO(239,239,239, 1);
  static Color dark_grey = Color.fromRGBO(112,112,112, 1);
  static Color medium_grey = Color.fromRGBO(132,132,132, 1);
  static Color medium_grey_50 = Color.fromRGBO(132,132,132, .5);
  static Color grey_153 = Color.fromRGBO(153,153,153, 1);
  static Color font_grey = Color.fromRGBO(73,73,73, 1);
  static Color textfield_grey = Color.fromRGBO(209,209,209, 1);
  static Color golden = HexColor("#fd7e14");
  static Color shimmer_base = Colors.grey.shade50;
  static Color shimmer_highlighted = Colors.grey.shade200;


  //testing shimmer
  /*static Color shimmer_base = Colors.redAccent;
  static Color shimmer_highlighted = Colors.yellow;*/



}