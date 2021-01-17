import 'package:eve_helper/data_structures.dart';
import 'package:eve_helper/helpers/local/local.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WormholeIdentifiersToolView extends StatefulWidget {
  WormholeIdentifiersToolView({Key key}) : super(key: key);

  @override
  _WormholeIdentifiersToolViewState createState() => _WormholeIdentifiersToolViewState();
}

class _WormholeIdentifiersToolViewState extends State<WormholeIdentifiersToolView> {
  List<WormholeInformation> _wormholes;

  Map<String, Color> _wormholeSystemClassToColor;

  TextEditingController _filterTEC;
  ValueNotifier _filterVN;

  @override
  void initState() {
    super.initState();

    _filterTEC = TextEditingController();
    _filterVN = ValueNotifier("");

    _wormholeSystemClassToColor = {
      'C1': Colors.blue,
      'C2': Colors.cyan,
      'C3': Colors.green,
      'C4': Colors.amber,
      'C5': Colors.orange,
      'C6': Colors.red,
      'H/L/N': Colors.green,
      'H/L': Colors.green,
      'H/N': Colors.green,
      'H': Colors.green,
      'L/N': Colors.amber,
      'L': Colors.amber,
      'N': Colors.red,
      'Thera': Colors.blueGrey,
      'C13': Colors.blueGrey,
      '?': Colors.black,
    };
  }

  @override
  void dispose() {
    super.dispose();

    _filterTEC.dispose();
    _filterVN.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wormhole Identifiers'),
      ),
      body: FutureBuilder(
        future: _initializeWormholes(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return ValueListenableBuilder(
              valueListenable: _filterVN,
              builder: (BuildContext context, value, Widget child) {
                return ListView(
                  children: [
                    CardTile(
                      title: Text('Filter'),
                      subtitle: TextFormField(
                        controller: _filterTEC,
                        onChanged: (value) {
                          _filterVN.value = value;
                        },
                      ),
                    ),
                    ..._buildWormholeCardTiles(),
                  ],
                );
              },
            );
          } else return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<bool> _initializeWormholes() async {
    if (_wormholes == null) _wormholes = await Local.getWormholes();
    return true;
  }

  List<Widget> _buildWormholeCardTiles() {
    var wormholes = _getFilteredWormholes();
    var widgets = <Widget>[];
    for(WormholeInformation wh in wormholes)
      widgets.add(_buildWormholeCardTile(context, wh));
    return widgets;
  }

  List<WormholeInformation> _getFilteredWormholes() {
    if (_filterTEC.text.isEmpty) return _wormholes;
    var filtered = <WormholeInformation>[];
    for(WormholeInformation wh in _wormholes)
      if(wh.identifier.toLowerCase().trim().contains(_filterTEC.text.toLowerCase().trim()))
        filtered.add(wh);
    return filtered;
  }

  Widget _buildWormholeCardTile(BuildContext context, WormholeInformation wh) {
    return CardTile(
      title: Text(wh.identifier),
      onTap: () {
        _showWormholeInformation(context, wh);
      },
    );
  }

  _showWormholeInformation(BuildContext context, WormholeInformation wh) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(wh.identifier),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Appears In'),
                Text(wh.appearsIn, style: TextStyle(color: _wormholeSystemClassToColor[wh.appearsIn])),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Destination'),
                Text(wh.destination, style: TextStyle(color: _wormholeSystemClassToColor[wh.destination])),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lifetime'),
                Text(wh.lifetime.toString()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Max Jump Mass'),
                Text(wh.maxMassPerJump.toString() + 'k tons'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Max Stable Mass'),
                Text(wh.totalJumpMass.toString() + 'k tons'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mass Regen'),
                Text(wh.massRegen.toString() + (wh.massRegen == 0 ? ' ton' : 'k tons')),
              ],
            ),
          ],
        ),
        actions: [
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}