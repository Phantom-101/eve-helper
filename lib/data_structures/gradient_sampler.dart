import 'dart:ui';

import 'package:flutter/material.dart';

class GradientSampler {
  final List<Color> colors;
  final List<double> stops;

  GradientSampler({this.colors, this.stops});

  Color evaluate(double position) {
    if (position < 0 || position > 1) throw Exception('evaluation position must be between 0 and 1');
    if (colors.length != stops.length) throw Exception ('there must be an equal number of colors and stops');
    if (position <= stops[0]) return colors[0];
    if (position >= stops[stops.length - 1]) return colors[colors.length - 1];
    double l, r;
    for(int i = 0; i < colors.length - 1; i++) {
      l = stops[i];
      r = stops[i + 1];
      if (r < l) throw Exception('stops must be increasing in magnitude');
      if (position >= l && position <= r) {
        double along = position - l;
        double percent = along / (r - l);
        return Color.lerp(colors[i], colors[i + 1], percent);
      }
    }
    return Colors.black;
  }
}
