import 'package:flutter/material.dart';

class Polyline {
  String polyline;
  String lineTitle;
  String color;

  Color get polylineColor {
    return Color(int.parse(color));
  }

  Polyline(this.polyline, this.lineTitle, this.color);

  Polyline.fromJson(parsedJson) {
    this.polyline = parsedJson["polyline"];
    this.lineTitle = parsedJson["lineTitle"];
    this.color = parsedJson["color"];
  }
}
