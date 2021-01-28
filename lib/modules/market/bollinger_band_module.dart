import 'package:eve_helper/data_structures/esi/market/market_history.dart';
import 'package:eve_helper/modules/module.dart';
import 'package:eve_helper/modules/module_input_slot.dart';
import 'package:eve_helper/widgets/zp_chart.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BollingerBandModule extends Module {
  BollingerBandModule() {
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
      title: Text('Bollinger Band'),
      subtitle: Text('The historic bollinger band of an item in a certain region.'),
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
          title: Text('Bollinger Band'),
          subtitle: history.length == 0 ? Text('No Data') : Container(
            child: ZPChart(
              zp: zp,
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                series: <ChartSeries>[
                  HiloOpenCloseSeries<MarketHistory, DateTime>(
                    name: 'OHLC',
                    borderWidth: 1,
                    dataSource: history.getRange(1, history.length).toList(),
                    xValueMapper: (e, _) => DateTime.parse(e.date),
                    openValueMapper: (e, _) => history[history.indexOf(e) - 1].average,
                    highValueMapper: (e, _) => e.highest,
                    lowValueMapper: (e, _) => e.lowest,
                    closeValueMapper: (e, _) => e.average,
                    volumeValueMapper: (e, _) => e.volume,
                  ),
                ],
                indicators: <TechnicalIndicators>[
                  BollingerBandIndicator<MarketHistory, DateTime>(
                    name: 'Bollinger',
                    seriesName: 'OHLC',
                    animationDuration: 0,
                    upperLineWidth: 1,
                    signalLineWidth: 1,
                    lowerLineWidth: 1,
                    period: 14,
                    standardDeviation: 1,
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
                  tooltipSettings: InteractiveTooltip(
                    arrowWidth: 0,
                    arrowLength: 0,
                    borderColor: Colors.transparent,
                  ),
                  tooltipAlignment: ChartAlignment.center,
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