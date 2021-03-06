import 'package:eve_helper/views/tool_views/navigation_tool_views/route_tool_view.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationToolSelectionView extends StatelessWidget {
  NavigationToolSelectionView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation Tools'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/systems.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('Route'),
            subtitle: Text('Series of jumps required to travel from point A to B.'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RouteToolView())),
          ),
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/mutation.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('Jump Route'),
            subtitle: Text('Series of jumps required to travel from point A to B.'),
            onTap: () => {},
          ),
        ],
      ),
    );
  }
}
