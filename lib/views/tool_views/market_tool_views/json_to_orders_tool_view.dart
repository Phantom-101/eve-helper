import 'dart:convert';
import 'dart:math';
import 'package:eve_helper/data_structures/esi/market/market_order.dart';
import 'package:eve_helper/helpers/local/cache.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class JsonToOrdersToolView extends StatefulWidget {
  JsonToOrdersToolView({Key key}) : super(key: key);

  @override
  _JsonToOrdersToolViewState createState() => _JsonToOrdersToolViewState();
}

class _JsonToOrdersToolViewState extends State<JsonToOrdersToolView> {
  TextEditingController _jsonTEC;

  ValueNotifier<List<MarketOrder>> _marketOrdersVN;
  ValueNotifier<bool> _dirtyVN;
  ValueNotifier<int> _pageVN;

  NumberFormat _formatter = NumberFormat('#,##0.00');

  @override
  void initState() {
    super.initState();

    _jsonTEC = TextEditingController();

    _marketOrdersVN = ValueNotifier<List<MarketOrder>>([]);
    _dirtyVN = ValueNotifier<bool>(false);
    _pageVN = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    super.dispose();

    _jsonTEC.dispose();

    _marketOrdersVN.dispose();
    _dirtyVN.dispose();
    _pageVN.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON to Orders'),
      ),
      body: ListView(
        children: [
          CardTile(
            title: Text('Parameters'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text('JSON'),
                TextFormField(
                  controller: _jsonTEC,
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: _submit,
                ),
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _dirtyVN,
            builder: (BuildContext context, value, Widget child) {
              if (_dirtyVN.value) return CardTile(title: CircularProgressIndicator());
              return ValueListenableBuilder(
                valueListenable: _marketOrdersVN,
                builder: (BuildContext context, value, Widget child) {
                  if (_marketOrdersVN.value.length == 0) return Container();
                  return ValueListenableBuilder(
                    valueListenable: _pageVN,
                    builder: (BuildContext context, int value, Widget child) {
                      return Column(
                        children: [
                          ..._getCardTiles(),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          CardTile(
            title: Text('Pagination'),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: Text('Previous Page'),
                  onPressed: () async {
                    _pageVN.value = max(_pageVN.value - 1, 0);
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: _pageVN,
                  builder: (BuildContext context, value, Widget child) {
                    return Text('Current Page: ${_pageVN.value + 1}');
                  },
                ),
                ElevatedButton(
                  child: Text('Next Page'),
                  onPressed: () async {
                    _pageVN.value = min(_pageVN.value + 1, (_marketOrdersVN.value.length / 10.0).ceil() - 1);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    _dirtyVN.value = true;

    _marketOrdersVN.value = json.decode(_jsonTEC.text).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>();

    _jsonTEC.text = '';

    _dirtyVN.value = false;
  }

  List<Widget> _getCardTiles() {
    List<Widget> res = [];
    for (int i = 10 * _pageVN.value; i < 10 * (_pageVN.value + 1); i++) {
      if (i >= _marketOrdersVN.value.length) break;
      final order = _marketOrdersVN.value[i];
      res.add(
        CardTile(
          title: FutureBuilder(
            key: UniqueKey(),
            future: context.read<Cache>().getItemName(order.typeId),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Text('${snapshot.data}');
              }
              return Text('Loading');
            },
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type: ${order.buyOrder ? 'Buy' : 'Sell'}'),
              Text('Price: ${_formatter.format(order.price)}'),
              Text('Volume: ${order.volumeRemain}/${order.volumeTotal}'),
              Text('Duration: ${order.duration}'),
              Text('Issued: ${order.issued}'),
            ],
          ),
        )
      );
    }
    return res;
  }
}
