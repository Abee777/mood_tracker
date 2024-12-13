import 'package:flutter/material.dart';

class Mood {
  final String name;
  final String icon;
  final Color color;
  String? note;

  Mood({required this.name, required this.icon, required this.color, this.note});
}