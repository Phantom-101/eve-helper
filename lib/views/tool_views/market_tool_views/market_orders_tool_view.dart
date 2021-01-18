import 'package:eve_helper/modules/items/item_information_module.dart';
import 'package:eve_helper/modules/market/buy_orders_module.dart';
import 'package:eve_helper/modules/market/depth_module.dart';
import 'package:eve_helper/modules/market/get_market_orders_module.dart';
import 'package:eve_helper/modules/market/sell_orders_module.dart';
import 'package:eve_helper/modules/parameters/item_and_region_parameters_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MarketOrdersToolView extends StatefulWidget {
  MarketOrdersToolView({Key key}) : super(key: key);

  @override
  _MarketOrdersToolViewState createState() => _MarketOrdersToolViewState();
}

class _MarketOrdersToolViewState extends State<MarketOrdersToolView> {
  ItemAndRegionParametersModule _parameters;
  ItemInformationModule _info;
  GetMarketOrdersModule _orders;
  BuyOrdersModule _buy;
  SellOrdersModule _sell;
  DepthModule _depth;

  @override
  void initState() {
    super.initState();

    _parameters = ItemAndRegionParametersModule();
    _info = ItemInformationModule();
    _orders = GetMarketOrdersModule();
    _buy = BuyOrdersModule();
    _sell = SellOrdersModule();
    _depth = DepthModule();
    _parameters.outputs[0].connect(_info.inputs[0]);
    _parameters.outputs[2].connect(_orders.inputs[2]);
    _orders.inputs[0].connect(_parameters.outputs[0]);
    _orders.inputs[1].connect(_parameters.outputs[1]);
    _orders.outputs[0].connect(_buy.inputs[0]);
    _orders.outputs[0].connect(_sell.inputs[0]);
    _orders.outputs[0].connect(_depth.inputs[0]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StaggeredGridView.count(
          crossAxisCount: 4,
          children: [
            _parameters.getWidgetCard(),
            _info.getWidgetCard(),
            _orders.getWidgetCard(),
            Divider(
              color: Colors.blueGrey[100],
              height: 32,
              thickness: 1,
            ),
            _buy.getWidgetCard(),
            _sell.getWidgetCard(),
            _depth.getWidgetCard(),
          ],
          staggeredTiles: [
            _parameters.getStaggeredTile(1),
            _info.getStaggeredTile(2),
            _orders.getStaggeredTile(1),
            StaggeredTile.fit(4),
            _buy.getStaggeredTile(2),
            _sell.getStaggeredTile(2),
            _depth.getStaggeredTile(4),
          ],
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          padding: const EdgeInsets.all(4.0),
        ),
      ),
    );
  }
}
