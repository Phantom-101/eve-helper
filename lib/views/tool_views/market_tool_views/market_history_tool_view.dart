import 'package:eve_helper/modules/items/item_information_module.dart';
import 'package:eve_helper/modules/market/market_historic_accumulation_distribution_module.dart';
import 'package:eve_helper/modules/market/market_historic_average_true_range_module.dart';
import 'package:eve_helper/modules/market/market_historic_bollinger_band_module.dart';
import 'package:eve_helper/modules/market/get_market_history_module.dart';
import 'package:eve_helper/modules/market/get_market_orders_module.dart';
import 'package:eve_helper/modules/market/market_depth_module.dart';
import 'package:eve_helper/modules/market/market_historic_pricing_module.dart';
import 'package:eve_helper/modules/market/market_historic_volume_module.dart';
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
  GetMarketOrdersModule _orders;
  GetMarketHistoryModule _history;
  MarketHistoricVolumeModule _volume;
  MarketDepthModule _depth;
  MarketHistoricPricingModule _pricing;
  MarketHistoricAccumulationDistributionModule _ad;
  MarketHistoricAverageTrueRangeModule _atr;
  MarketHistoricBollingerBandModule _bollinger;

  @override
  void initState() {
    super.initState();

    _parameters = ItemAndRegionParametersModule();
    _info = ItemInformationModule();
    _orders = GetMarketOrdersModule();
    _history = GetMarketHistoryModule();
    _pricing = MarketHistoricPricingModule();
    _volume = MarketHistoricVolumeModule();
    _depth = MarketDepthModule();
    _ad = MarketHistoricAccumulationDistributionModule();
    _atr = MarketHistoricAverageTrueRangeModule();
    _bollinger = MarketHistoricBollingerBandModule();
    _parameters.outputs[0].connect(_info.inputs[0]);
    _parameters.outputs[2].connect(_orders.inputs[2]);
    _parameters.outputs[2].connect(_history.inputs[2]);
    _orders.inputs[0].connect(_parameters.outputs[0]);
    _orders.inputs[1].connect(_parameters.outputs[1]);
    _orders.outputs[0].connect(_depth.inputs[0]);
    _history.inputs[0].connect(_parameters.outputs[0]);
    _history.inputs[1].connect(_parameters.outputs[1]);
    _history.outputs[0].connect(_pricing.inputs[0]);
    _history.outputs[0].connect(_volume.inputs[0]);
    _history.outputs[0].connect(_ad.inputs[0]);
    _history.outputs[0].connect(_atr.inputs[0]);
    _history.outputs[0].connect(_bollinger.inputs[0]);
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
            _orders.getWidgetCard(),
            _history.getWidgetCard(),
            _pricing.getWidgetCard(),
            _volume.getWidgetCard(),
            _depth.getWidgetCard(),
            _ad.getWidgetCard(),
            _atr.getWidgetCard(),
            _bollinger.getWidgetCard(),
          ],
          staggeredTiles: [
            _parameters.getStaggeredTile(),
            _info.getStaggeredTile(),
            _orders.getStaggeredTile(),
            _history.getStaggeredTile(),
            _pricing.getStaggeredTile(),
            _volume.getStaggeredTile(),
            _depth.getStaggeredTile(),
            _ad.getStaggeredTile(),
            _atr.getStaggeredTile(),
            _bollinger.getStaggeredTile(),
          ],
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          padding: const EdgeInsets.all(4.0),
        ),
      ),
    );
  }
}
