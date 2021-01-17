import 'package:eve_helper/views/tool_views/industry_tool_views/manufacturing_tool_view.dart';
import 'package:eve_helper/views/tool_views/industry_tool_views/pi_tool_view.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndustryToolSelectionView extends StatelessWidget {
  IndustryToolSelectionView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Industry Tools'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/Industry.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('Manufacturing'),
            subtitle: Text('Blueprint profit margin and cost calculator.'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ManufacturingToolView())),
          ),
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/research.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('Invention'),
            subtitle: Text('Information regarding invention.'),
            onTap: () => {},
          ),
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/planets.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('PI'),
            subtitle: Text('Calculator for PI setup expenses and projected ISK per hour.'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PIToolView())),
          ),
        ],
      ),
    );
  }
}
