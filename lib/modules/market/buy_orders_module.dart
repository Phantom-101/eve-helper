import 'package:eve_helper/data_structures/esi/market/market_order.dart';
import 'package:eve_helper/helpers/local/cache.dart';
import 'package:eve_helper/modules/module.dart';
import 'package:eve_helper/modules/module_input_slot.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

class BuyOrdersModule extends Module {
  NumberFormat _formatter = NumberFormat('#,##0.00');

  BuyOrdersModule() {
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
      title: Text('Buy Orders'),
      subtitle: Text('The current buy orders of an item in a certain region.'),
      onTap: onAdd,
    );
  }

  @override
  Widget getWidgetCard () {
    return AnimatedBuilder(
      animation: getListenable(),
      builder: (context, child) {
        List<MarketOrder> orders = inputs[0].getValue().where((MarketOrder e) => e.buyOrder).toList()..sort((MarketOrder a, MarketOrder b) => -a.price.compareTo(b.price));
        return CardTile(
          title: Text('Buy Orders'),
          subtitle: orders.length == 0 ? Text('No Data') : Container(
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
                        ? Cache.getStructureInformation(orders[index].locationId)
                        : Cache.getStationInformation(orders[index].locationId),
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
    );
  }

  @override
  StaggeredTile getStaggeredTile(int size) {
    return StaggeredTile.fit(size);
  }
}