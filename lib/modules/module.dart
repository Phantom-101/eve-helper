import 'package:eve_helper/modules/module_input_slot.dart';
import 'package:eve_helper/modules/module_output_slot.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Module {
  List<ModuleInputSlot> inputs = [];
  List<ModuleOutputSlot> outputs = [];
  Listenable _listenable;

  Widget getInfoCard(VoidCallback onAddModule) {
    return CardTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset('assets/Icons/UI/WindowIcons/market.png', color: Colors.black, fit: BoxFit.fill),
      ),
      title: Text('Base Module'),
      subtitle: Text('A useless module.'),
      onTap: onAddModule,
    );
  }

  Widget getWidgetCard() {
    return CardTile(
      title: Text('Base Module'),
    );
  }

  StaggeredTile getStaggeredTile(int size) {
    return StaggeredTile.extent(1, 1);
  }

  @protected
  void setListenable () {
    final all = [...inputs, ...outputs].map((e) => e.getVN()).toList();
    _listenable = Listenable.merge(all);
  }

  Listenable getListenable () {
    return _listenable;
  }
}
