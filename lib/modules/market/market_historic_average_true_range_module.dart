import 'dart:math';
import 'package:eve_helper/data_structures/esi/market/market_history.dart';
import 'package:eve_helper/modules/module.dart';
import 'package:eve_helper/modules/module_input_slot.dart';
import 'package:eve_helper/widgets/zp_chart.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MarketHistoricAverageTrueRangeModule extends Module {
  MarketHistoricAverageTrueRangeModule() {
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
      title: Text('Market Historic Average True Range'),
      subtitle: Text('The historic average true range of an item in a certain region.'),
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
          title: Text('Market Historic Average True Range'),
          subtitle: history.length == 0 ? Text('No Data') : Container(
            child: ZPChart(
              zp: zp,
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                axes: [
                  NumericAxis(
                    name: 'ATR',
                    opposedPosition: true,
                  ),
                ],
                series: <ChartSeries>[
                  HiloOpenCloseSeries<MarketHistory, DateTime>(
                    name: 'OHLC',
                    borderWidth: 1,
                    dataSource: history.getRange(1, history.length).toList(),
                    xValueMapper: (e, _) => DateTime.parse(e.date),
                    openValueMapper: (e, _) => history[history.indexOf(e) - 1].average,
                    highValueMapper: (e, _) => max(e.highest, max(e.average, history[history.indexOf(e) - 1].average)),
                    lowValueMapper: (e, _) => min(e.lowest, min(e.average, history[history.indexOf(e) - 1].average)),
                    closeValueMapper: (e, _) => e.average,
                    volumeValueMapper: (e, _) => e.volume,
                  ),
                ],
                indicators: <TechnicalIndicators>[
                  AtrIndicator<MarketHistory, DateTime>(
                    name: 'ATR',
                    seriesName: 'OHLC',
                    signalLineWidth: 1,
                    yAxisName: 'ATR',
                  ),
                ],
                legend: Legend(
                  isVisible: true,
                ),
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                  tooltipSettings: InteractiveTooltip(
                    color: Colors.blueGrey[700],
                    borderColor: Colors.blueGrey[900],
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
  StaggeredTile getStaggeredTile() {
    return StaggeredTile.fit(2);
  }
}