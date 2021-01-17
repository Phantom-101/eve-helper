import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PvEToolSelectionView extends StatelessWidget {
  PvEToolSelectionView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PvE Tools'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/combatlog.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('Ratting'),
            subtitle: Text('Information for NPC spawns of various combat sites.'),
            onTap: () => {},
          ),
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/mutation.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('Sites'),
            subtitle: Text('Possible sites that could spawn in a specified region type.'),
            onTap: () => {},
          ),
        ],
      ),
    );
  }
}
