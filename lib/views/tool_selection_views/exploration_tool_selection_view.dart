import 'package:eve_helper/views/tool_views/exploration_tool_views/wormhole_identifiers_tool_view.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExplorationToolSelectionView extends StatelessWidget {
  ExplorationToolSelectionView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exploration Tools'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/mutation.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('Wormhole Identifiers'),
            subtitle: Text('Using a wormhole\'s id to find out more about where it leads to.'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WormholeIdentifiersToolView())),
          ),
        ],
      ),
    );
  }
}
