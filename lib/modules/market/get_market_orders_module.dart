import 'package:eve_helper/data_structures/esi/market/market_order.dart';
import 'package:eve_helper/helpers/local/cache.dart';
import 'package:eve_helper/modules/module.dart';
import 'package:eve_helper/modules/module_input_slot.dart';
import 'package:eve_helper/modules/module_output_slot.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GetMarketOrdersModule extends Module {
  String _msg;

  GetMarketOrdersModule() {
    inputs.add(ModuleInputSlot<String>(name: 'item_name', value: '', module: this));
    inputs.add(ModuleInputSlot<String>(name: 'region_name', value: '', module: this));
    inputs.add(ModuleInputSlot<bool>(name: 'active', value: false, module: this));
    outputs.add(ModuleOutputSlot<List<MarketOrder>>(name: 'orders', value: <MarketOrder>[], module: this));
    setListenable();

    _msg = 'Ready';
  }

  @override
  Widget getInfoCard (VoidCallback onAdd) {
    return CardTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset('assets/Icons/UI/WindowIcons/market.png', color: Colors.black, fit: BoxFit.fill),
      ),
      title: Text('Get Market Orders'),
      subtitle: Text('Gets the orders of an item in a certain region.'),
      onTap: onAdd,
    );
  }

  @override
  Widget getWidgetCard () {
    return AnimatedBuilder(
      animation: getListenable(),
      builder: (context, child) {
        if (_canGetValue()) {
          _msg = 'Loading';
          _getValues();
        }
        return CardTile(
          title: Row(
            children: [
              Text('Get Market Orders'),
              SizedBox(width: 8),
              Container(
                height: 12,
                width: 12,
                child: _msg == 'Loading' ? CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  backgroundColor: Colors.grey,
                ) : CircularProgressIndicator(
                  strokeWidth: 4,
                  value: 1,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getValues() async {
    var itemId, regionId;
    try {
      itemId = await Cache.getItemId(inputs[0].getValue());
      regionId = await Cache.getRegionId(inputs[1].getValue());
    } on Exception catch (e) {
      _msg = 'Error';
      inputs[2].setValue(false);
      outputs[0].setValue(<MarketOrder>[]);
      print(e);
      return;
    }

    try {
      List<MarketOrder> res = await Cache.getMarketOrders(regionId, itemId);
      _msg = 'Loaded';
      inputs[2].setValue(false);
      outputs[0].setValue(res);
    } on Exception catch (e) {
      _msg = 'Error';
      inputs[2].setValue(false);
      outputs[0].setValue(<MarketOrder>[]);
      print(e);
    }
  }

  bool _canGetValue () {
    if (_msg == 'Loading') return false;
    if (inputs[0].getValue()?.isEmpty ?? true) return false;
    if (inputs[1].getValue()?.isEmpty ?? true) return false;
    return inputs[2].getValue();
  }

  @override
  StaggeredTile getStaggeredTile() {
    return StaggeredTile.fit(1);
  }
}