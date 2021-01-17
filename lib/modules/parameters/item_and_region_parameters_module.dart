import 'package:eve_helper/modules/module.dart';
import 'package:eve_helper/modules/module_output_slot.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ItemAndRegionParametersModule extends Module {
  TextEditingController _itemTEC;
  TextEditingController _regionTEC;

  ItemAndRegionParametersModule() {
    outputs.add(ModuleOutputSlot<String>(name: 'item-name', value: '', module: this));
    outputs.add(ModuleOutputSlot<String>(name: 'region-name', value: '', module: this));
    outputs.add(ModuleOutputSlot<bool>(name: 'trigger', value: false, module: this));
    setListenable();

    _itemTEC = TextEditingController();
    _regionTEC = TextEditingController();
  }

  @override
  Widget getInfoCard (VoidCallback onAdd) {
    return CardTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset('assets/Icons/UI/WindowIcons/market.png', color: Colors.black, fit: BoxFit.fill),
      ),
      title: Text('Market Depth'),
      subtitle: Text('The depth of an item in a region\'s market.'),
      onTap: onAdd,
    );
  }

  @override
  Widget getWidgetCard () {
    return CardTile(
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
          Text('Region'),
          TextFormField(
            controller: _regionTEC,
          ),
          SizedBox(height: 8),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () {
              outputs[0].setValue(_itemTEC.text);
              outputs[1].setValue(_regionTEC.text);
              outputs[2].setValue(true);
            },
          ),
        ],
      ),
    );
  }

  @override
  StaggeredTile getStaggeredTile() {
    return StaggeredTile.fit(1);
  }
}