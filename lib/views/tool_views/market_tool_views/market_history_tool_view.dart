import 'package:eve_helper/modules/items/item_information_module.dart';
import 'package:eve_helper/modules/market/get_market_history_module.dart';
import 'package:eve_helper/modules/market/historic_pricing_module.dart';
import 'package:eve_helper/modules/market/historic_volume_module.dart';
import 'package:eve_helper/modules/parameters/item_and_region_parameters_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MarketHistoryToolView extends StatefulWidget {
  MarketHistoryToolView({Key key}) : super(key: key);

  @override
  _MarketHistoryToolViewState createState() => _MarketHistoryToolViewState();
}

class _MarketHistoryToolViewState extends State<MarketHistoryToolView> {
  ItemAndRegionParametersModule _parameters;
  ItemInformationModule _info;
  GetMarketHistoryModule _history;
  HistoricVolumeModule _volume;
  HistoricPricingModule _pricing;

  @override
  void initState() {
    super.initState();

    _parameters = ItemAndRegionParametersModule();
    _info = ItemInformationModule();
    _history = GetMarketHistoryModule();
    _pricing = HistoricPricingModule();
    _volume = HistoricVolumeModule();
    _parameters.outputs[0].connect(_info.inputs[0]);
    _parameters.outputs[2].connect(_history.inputs[2]);
    _history.inputs[0].connect(_parameters.outputs[0]);
    _history.inputs[1].connect(_parameters.outputs[1]);
    _history.outputs[0].connect(_pricing.inputs[0]);
    _history.outputs[0].connect(_volume.inputs[0]);
  }

  @override
  void dispose() {
    super.dispose();
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
            _parameters.getWidgetCard(),
            _info.getWidgetCard(),
            _history.getWidgetCard(),
            Divider(
              color: Colors.blueGrey[100],
              height: 32,
              thickness: 1,
            ),
            _pricing.getWidgetCard(),
            _volume.getWidgetCard(),
          ],
          staggeredTiles: [
            _parameters.getStaggeredTile(1),
            _info.getStaggeredTile(2),
            _history.getStaggeredTile(1),
            StaggeredTile.fit(4),
            _pricing.getStaggeredTile(2),
            _volume.getStaggeredTile(2),
          ],
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          padding: const EdgeInsets.all(4.0),
        ),
      ),
    );
  }
}
