import 'package:eve_helper/data_structures/esi/market/market_history.dart';
import 'package:eve_helper/modules/module.dart';
import 'package:eve_helper/modules/module_input_slot.dart';
import 'package:eve_helper/widgets/zp_chart.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistoricPricingModule extends Module {
  HistoricPricingModule() {
    inputs.add(ModuleInputSlot<List<MarketHistory>>(name: 'history', value: <MarketHistory>[], module: this));
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
      title: Text('Historic Pricing'),
      subtitle: Text('The historic pricing of an item in a certain region.'),
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
        List<MarketHistory> history = inputs[0].getValue();
        return CardTile(
          title: Text('Historic Pricing'),
          subtitle: history.length == 0 ? Text('No Data') : Container(
            child: ZPChart(
              zp: zp,
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                series: <ChartSeries>[
                  FastLineSeries<MarketHistory, DateTime>(
                    name: 'Highest',
                    color: Colors.red,
                    width: 1,
                    dataSource: history,
                    xValueMapper: (e, _) => DateTime.parse(e.date),
                    yValueMapper: (e, _) => e.highest,
                  ),
                  FastLineSeries<MarketHistory, DateTime>(
                    name: 'Average',
                    color: Colors.blue,
                    width: 1,
                    dataSource: history,
                    xValueMapper: (e, _) => DateTime.parse(e.date),
                    yValueMapper: (e, _) => e.average,
                  ),
                  FastLineSeries<MarketHistory, DateTime>(
                    name: 'Lowest',
                    color: Colors.green,
                    width: 1,
                    dataSource: history,
                    xValueMapper: (e, _) => DateTime.parse(e.date),
                    yValueMapper: (e, _) => e.lowest,
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
                        '${DateFormat('MMMMd').format(details.point.x)} ${details.series.name}: ${details.point.y}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
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