import 'package:eve_helper/helpers/local/cache.dart';
import 'package:eve_helper/modules/module.dart';
import 'package:eve_helper/modules/module_input_slot.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

class ItemInformationModule extends Module {
  NumberFormat _formatter = NumberFormat('#,##0.00');

  ItemInformationModule() {
    inputs.add(ModuleInputSlot<String>(name: 'item-name', value: '', module: this));
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
      title: Text('Item Information'),
      subtitle: Text('Basic information on an item.'),
      onTap: onAdd,
    );
  }

  @override
  Widget getWidgetCard () {
    return AnimatedBuilder(
      animation: getListenable(),
      builder: (context, child) {
        return CardTile(
          leading: inputs[0].getValue().toString().isEmpty ? Container() : Container(
            width: 64,
            height: 64,
            child: FutureBuilder(
              future: Cache.getItemId(inputs[0].getValue()),
              builder: (context, value) {
                if (value.hasData) return Image.network('https://images.evetech.net/types/${value.data}/icon');
                else if (value.hasError) return Icon(Icons.error);
                return CircularProgressIndicator();
              },
            ),
          ),
          title: inputs[0].getValue().toString().isEmpty ? Text('Item Information') : Text(inputs[0].getValue()),
          subtitle: inputs[0].getValue().toString().isEmpty ? Text('No Data') : FutureBuilder(
            future: Cache.getItemId(inputs[0].getValue()),
            builder: (context, itemId) {
              if (itemId.hasData) return FutureBuilder(
                future: Cache.getSystemId('Jita'),
                builder: (context, systemId) {
                  if (systemId.hasData) return FutureBuilder(
                    future: Cache.getMarketStats(systemId.data, itemId.data),
                    builder: (context, price) {
                      if (price.hasData) return Text('Jita Min Sell Price: ${_formatter.format(price.data.minSell)}');
                      if (price.hasError) return Text('Error');
                      return Text('Jita Min Sell Price: Loading');
                    },
                  );
                  if (systemId.hasError) return Text('Error');
                  return Text('Jita Min Sell Price: Loading');
                },
              );
              else if (itemId.hasError) return Text('Error');
              return Text('Jita Min Sell Price: Loading');
            },
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