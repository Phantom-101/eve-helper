import 'package:eve_helper/widgets/button_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ZPChart extends StatelessWidget {
  final Widget child;
  final ZoomPanBehavior zp;

  ZPChart({@required this.child, @required this.zp});

  @override
  Widget build(BuildContext context) {
    return ButtonBarChart(
      child: child,
      buttons: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            zp.zoomIn();
          },
        ),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            zp.zoomOut();
          },
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_up),
          onPressed: () {
            zp.panToDirection('top');
          },
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            zp.panToDirection('bottom');
          },
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            zp.panToDirection('left');
          },
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_right),
          onPressed: () {
            zp.panToDirection('right');
          },
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            zp.reset();
          },
        ),
      ],
    );
  }
}
