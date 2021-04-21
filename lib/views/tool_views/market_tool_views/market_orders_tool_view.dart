import 'package:eve_helper/data_structures/esi/market/market_order.dart';
import 'package:eve_helper/helpers/local/cache.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:eve_helper/widgets/progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MarketOrdersToolView extends StatefulWidget {
  MarketOrdersToolView({Key key}) : super(key: key);

  @override
  _MarketOrdersToolViewState createState() => _MarketOrdersToolViewState();
}

class _MarketOrdersToolViewState extends State<MarketOrdersToolView> {
  TextEditingController _itemTEC = TextEditingController(text: '');
  TextEditingController _regionTEC = TextEditingController(text: '');
  ValueNotifier<String> _itemVN = ValueNotifier('');
  ValueNotifier<String> _regionVN = ValueNotifier('');
  Progress _getItemId = Progress();
  Progress _getRegionId = Progress();
  Progress _getBuyOrders = Progress();
  Progress _getSellOrders = Progress();
  ValueNotifier<List<MarketOrder>> _buys = ValueNotifier(<MarketOrder>[]);
  ValueNotifier<List<MarketOrder>> _sells = ValueNotifier(<MarketOrder>[]);
  NumberFormat _formatter = NumberFormat('#,##0.00');

  @override
  void dispose() {
    super.dispose();
    _itemTEC.dispose();
    _regionTEC.dispose();
    _itemVN.dispose();
    _regionVN.dispose();
    _buys.dispose();
    _sells.dispose();
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
                      Text('Get Buy Orders'),
                      SizedBox(width: 8),
                      _getBuyOrders.getWidget(12),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Get Sell Orders'),
                      SizedBox(width: 8),
                      _getSellOrders.getWidget(12),
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
              valueListenable: _buys,
              builder: (context, orders, child) {
                return CardTile(
                  title: Text('Buy Orders'),
                  subtitle: (orders ?? <MarketOrder>[]).length == 0 ? Text('No Data') : Container(
                    height: 500,
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) => CardTile(
                        title: Text('${_formatter.format(orders[index].price)} ISK'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Volume: ${orders[index].volumeRemain}/${orders[index].volumeTotal}'),
                            FutureBuilder(
                              future: orders[index].locationId >= 1000000000
                                  ? context.read<Cache>().getStructureInformation(orders[index].locationId)
                                  : context.read<Cache>().getStationInformation(orders[index].locationId),
                              builder: (context, value) {
                                if (value.hasData) return Text('Location: ${value.data.name}');
                                if (value.hasError) return Text('Location: Unknown');
                                return Text('Location: Loading...');
                              },
                            ),
                            Text('Expiration: ${DateTime.parse(orders[index].issued).add(Duration(days: orders[index].duration))}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: _sells,
              builder: (context, orders, child) {
                return CardTile(
                  title: Text('Sell Orders'),
                  subtitle: (orders ?? <MarketOrder>[]).length == 0 ? Text('No Data') : Container(
                    height: 500,
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) => CardTile(
                        title: Text('${_formatter.format(orders[index].price)} ISK'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Volume: ${orders[index].volumeRemain}/${orders[index].volumeTotal}'),
                            FutureBuilder(
                              future: orders[index].locationId >= 1000000000
                                  ? context.read<Cache>().getStructureInformation(orders[index].locationId)
                                  : context.read<Cache>().getStationInformation(orders[index].locationId),
                              builder: (context, value) {
                                if (value.hasData) return Text('Location: ${value.data.name}');
                                if (value.hasError) return Text('Location: Unknown');
                                return Text('Location: Loading...');
                              },
                            ),
                            Text('Expiration: ${DateTime.parse(orders[index].issued).add(Duration(days: orders[index].duration))}'),
                          ],
                        ),
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
        var buys = <MarketOrder>[];
        try {
          _getBuyOrders.start(1);
          buys = await context.read<Cache>().getItemMarketBuyOrders(regionId, itemId);
          _getBuyOrders.progress.value++;
          _buys.value = buys..sort((a, b) => -a.price.compareTo(b.price));
        } catch(e) {
          print(e);
          _getBuyOrders.err();
        }
        var sells = <MarketOrder>[];
        try {
          _getSellOrders.start(1);
          sells = await context.read<Cache>().getItemMarketSellOrders(regionId, itemId);
          _getSellOrders.progress.value++;
          _sells.value = sells..sort((a, b) => a.price.compareTo(b.price));
        } catch(e) {
          print(e);
          _getSellOrders.err();
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
