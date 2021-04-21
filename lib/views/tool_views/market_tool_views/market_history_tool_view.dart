import 'package:eve_helper/data_structures/esi/market/market_history.dart';
import 'package:eve_helper/helpers/local/cache.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:eve_helper/widgets/progress_indicator.dart';
import 'package:eve_helper/widgets/zp_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MarketHistoryToolView extends StatefulWidget {
  MarketHistoryToolView({Key key}) : super(key: key);

  @override
  _MarketHistoryToolViewState createState() => _MarketHistoryToolViewState();
}

class _MarketHistoryToolViewState extends State<MarketHistoryToolView> {
  TextEditingController _itemTEC = TextEditingController(text: '');
  TextEditingController _regionTEC = TextEditingController(text: '');
  ValueNotifier<String> _itemVN = ValueNotifier('');
  ValueNotifier<String> _regionVN = ValueNotifier('');
  Progress _getItemId = Progress();
  Progress _getRegionId = Progress();
  Progress _getHistory = Progress();
  ValueNotifier<List<MarketHistory>> _history = ValueNotifier(<MarketHistory>[]);
  ZoomPanBehavior _pricingZp = ZoomPanBehavior(enableSelectionZooming: true, enablePanning: true);
  ZoomPanBehavior _volumeZp = ZoomPanBehavior(enableSelectionZooming: true, enablePanning: true);

  @override
  void dispose() {
    super.dispose();
    _itemTEC.dispose();
    _regionTEC.dispose();
    _itemVN.dispose();
    _regionVN.dispose();
    _history.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StaggeredGridView.count(
          crossAxisCount: 4,
          children: [
            CardTile(
              title: Text('Parameters'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text('Item Name'),
                  TextFormField(
                    controller: _itemTEC,
                  ),
                  SizedBox(height: 8),
                  Text('Region Name'),
                  TextFormField(
                    controller: _regionTEC,
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    child: Text('Submit'),
                    onPressed: () {
                      _itemVN.value = _itemTEC.text;
                      _regionVN.value = _regionTEC.text;
                      _onSubmit();
                    },
                  ),
                ],
              ),
            ),
            CardTile(
              title: Text('Query Status'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Get Item Id'),
                      SizedBox(width: 8),
                      _getItemId.getWidget(12),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Get Region Id'),
                      SizedBox(width: 8),
                      _getRegionId.getWidget(12),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Get History'),
                      SizedBox(width: 8),
                      _getHistory.getWidget(12),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.blueGrey[100],
              height: 32,
              thickness: 1,
            ),
            ValueListenableBuilder(
              valueListenable: _history,
              builder: (context, history, child) {
                return CardTile(
                  title: Text('Historic Pricing'),
                  subtitle: (history ?? <MarketHistory>[]).length == 0 ? Text('No Data') : Container(
                    child: ZPChart(
                      zp: _pricingZp,
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
                        zoomPanBehavior: _pricingZp,
                      ),
                    ),
                  ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: _history,
              builder: (context, history, child) {
                return CardTile(
                  title: Text('Historic Volume'),
                  subtitle: (history ?? <MarketHistory>[]).length == 0 ? Text('No Data') : Container(
                    child: ZPChart(
                      zp: _volumeZp,
                      child: SfCartesianChart(
                        primaryXAxis: DateTimeAxis(),
                        series: <ChartSeries>[
                          AreaSeries<MarketHistory, DateTime>(
                            name: 'Volume',
                            color: Colors.blue[100],
                            borderColor: Colors.blue,
                            borderWidth: 1,
                            dataSource: history,
                            xValueMapper: (e, _) => DateTime.parse(e.date),
                            yValueMapper: (e, _) => e.volume,
                            yAxisName: 'Volume',
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
                        zoomPanBehavior: _volumeZp,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
          staggeredTiles: [
            StaggeredTile.fit(2),
            StaggeredTile.fit(2),
            StaggeredTile.fit(4),
            StaggeredTile.fit(2),
            StaggeredTile.fit(2),
          ],
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          padding: const EdgeInsets.all(4.0),
        ),
      ),
    );
  }

  void _onSubmit() async {
    var itemId;
    try {
      _getItemId.start(1);
      itemId = await context.read<Cache>().getItemId(_itemVN.value);
      _getItemId.progress.value++;
      var regionId;
      try {
        _getRegionId.start(1);
        regionId = await context.read<Cache>().getRegionId(_regionVN.value);
        _getRegionId.progress.value++;
        var history = <MarketHistory>[];
        try {
          _getHistory.start(1);
          history = await context.read<Cache>().getMarketHistory(regionId, itemId);
          _getHistory.progress.value++;
          _history.value = history;
        } catch(e) {
          print(e);
          _getHistory.err();
        }
      } catch(e) {
        print(e);
        _getRegionId.err();
      }
    } catch(e) {
      print(e);
      _getItemId.err();
    }
  }
}
