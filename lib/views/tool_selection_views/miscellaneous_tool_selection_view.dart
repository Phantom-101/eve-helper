import 'package:eve_helper/views/tool_views/navigation_tool_views/route_tool_view.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MiscellaneousToolSelectionView extends StatelessWidget {
  MiscellaneousToolSelectionView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Miscellaneous Tools'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/planetarycommodities.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('POS Planner'),
            subtitle: Text('Tool to plan out your POS services and defenses.'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RouteToolView())),
          ),
        ],
      ),
    );
  }
}
