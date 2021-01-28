import 'package:eve_helper/data_structures/esi/market/market_order.dart';
import 'package:eve_helper/modules/module.dart';
import 'package:eve_helper/modules/module_input_slot.dart';
import 'package:eve_helper/widgets/zp_chart.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DepthModule extends Module {
  DepthModule() {
    inputs.add(ModuleInputSlot<List<MarketOrder>>(name: 'orders', value: <MarketOrder>[], module: this));
    setListenable();
  }

  @override
  Widget getInfoCard (VoidCallback onAdd) {
    return CardTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset('assets/Icons/UI/WindowIcons/market.png', color: Colors.black, fit: BoxFit.fill),
      ),
      title: Text('Depth'),
      subtitle: Text('The depth of an item in a region\'s market.'),
      onTap: onAdd,
    );
  }

  @override
  Widget getWidgetCard () {
    var zp = ZoomPanBehavior(
      enableSelectionZooming: true,
      enablePanning: true,
    );
    return AnimatedBuilder(
      animation: getListenable(),
      builder: (context, child) {
        List<MarketOrder> orders = inputs[0].getValue();
        Map<double, int> sellDepth = {};
        Map<double, int> buyDepth = {};
        orders.forEach((e) {
          if (e.buyOrder) {
            buyDepth[e.price] = (buyDepth[e.price] ?? 0) + e.volumeRemain;
            sellDepth[e.price] = sellDepth[e.price] ?? 0;
          } else {
            sellDepth[e.price] = (sellDepth[e.price] ?? 0) + e.volumeRemain;
            buyDepth[e.price] = buyDepth[e.price] ?? 0;
          }
        });
        return CardTile(
          title: Text('Depth'),
          subtitle: orders.length == 0 ? Text('No Data') : Container(
            child: ZPChart(
              zp: zp,
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(),
                series: <ChartSeries>[
                  AreaSeries<double, num>(
                    name: 'Sells',
                    color: Colors.red[100],
                    borderColor: Colors.red,
                    borderWidth: 1,
                    dataSource: sellDepth.keys.toList()..sort(),
                    xValueMapper: (e, _) => e,
                    yValueMapper: (e, _) => sellDepth[e],
                  ),
                  AreaSeries<double, num>(
                    name: 'Buys',
                    color: Colors.blue[100],
                    borderColor: Colors.blue,
                    borderWidth: 1,
                    dataSource: buyDepth.keys.toList()..sort(),
                    xValueMapper: (e, _) => e,
                    yValueMapper: (e, _) => buyDepth[e],
                  ),
                ],
                legend: Legend(
                  isVisible: true,
                ),
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  builder: (context, details) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        '${details.series.name} at ${details.point.x}: ${details.point.y}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                  tooltipSettings: InteractiveTooltip(
                    arrowWidth: 0,
                    arrowLength: 0,
                    borderColor: Colors.transparent,
                  ),
                  markerSettings: TrackballMarkerSettings(
                    markerVisibility: TrackballVisibilityMode.visible,
                    shape: DataMarkerType.circle,
                    color: Colors.blue[100],
                    borderColor: Colors.blue,
                    width: 4,
                    height: 4,
                    borderWidth: 4,
                  ),
                ),
                zoomPanBehavior: zp,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  StaggeredTile getStaggeredTile(int size) {
    return StaggeredTile.fit(size);
  }
}