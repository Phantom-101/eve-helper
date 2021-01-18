import 'package:eve_helper/views/tool_views/market_tool_views/json_to_orders_tool_view.dart';
import 'package:eve_helper/views/tool_views/market_tool_views/market_history_tool_view.dart';
import 'package:eve_helper/views/tool_views/market_tool_views/market_orders_tool_view.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarketToolSelectionView extends StatelessWidget {
  MarketToolSelectionView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market Tools'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/market.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('Market History'),
            subtitle: Text('Retrieves the history of an item in a region.'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MarketHistoryToolView())),
          ),
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/market.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('Market Orders'),
            subtitle: Text('Retrieves the orders of an item in a region.'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MarketOrdersToolView())),
          ),
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/market.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('JSON to Orders'),
            subtitle: Text('Converts an EVE ESI JSON string containing market orders into readable cards.'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => JsonToOrdersToolView())),
          ),
        ],
      ),
    );
  }
}
