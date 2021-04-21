import 'package:eve_helper/data_structures.dart';
import 'package:eve_helper/data_structures/gradient_sampler.dart';
import 'package:eve_helper/helpers/esi/routes_api.dart';
import 'package:eve_helper/helpers/esi/search_api.dart';
import 'package:eve_helper/helpers/kybernaut/kybernaut.dart';
import 'package:eve_helper/helpers/local/cache.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteToolView extends StatefulWidget {
  RouteToolView({Key key}) : super(key: key);

  @override
  _RouteToolViewState createState() => _RouteToolViewState();
}

class _RouteToolViewState extends State<RouteToolView> {
  List<InvadedSolarSystemInformation> _invadedSolarSystemInformation;

  GradientSampler _securityStatusGradient;

  TextEditingController _originTEC;
  TextEditingController _destinationTEC;

  ValueNotifier _submitVN;
  ValueNotifier _dirtyVN;
  ValueNotifier _flagVN;

  Widget _cached;

  @override
  void initState() {
    super.initState();

    _securityStatusGradient = GradientSampler(
      colors: [Colors.redAccent, Colors.yellowAccent, Colors.cyanAccent],
      stops: [0.5, 0.75, 1],
    );

    _originTEC = TextEditingController();
    _destinationTEC = TextEditingController();

    _submitVN = ValueNotifier(true);
    _dirtyVN = ValueNotifier(false);
    _flagVN = ValueNotifier('shortest');

    _cached = CardTile(title: Text('No Route'));
  }

  @override
  void dispose() {
    super.dispose();

    _originTEC.dispose();
    _destinationTEC.dispose();

    _submitVN.dispose();
    _dirtyVN.dispose();
    _flagVN.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _submitVN,
        builder: (BuildContext context, value, Widget child) {
          return ListView(
            children: [
              CardTile(
                title: Text('Routing Settings'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text('Origin'),
                    TextFormField(
                      controller: _originTEC,
                    ),
                    SizedBox(height: 8),
                    Text('Destination'),
                    TextFormField(
                      controller: _destinationTEC,
                    ),
                    SizedBox(height: 8),
                    Text('Flag'),
                    ValueListenableBuilder(
                      valueListenable: _flagVN,
                      builder: (BuildContext context, value, Widget child) {
                        return DropdownButton<String>(
                          value: _flagVN.value,
                          items: <String>['shortest', 'secure', 'insecure']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _flagVN.value = value;
                          },
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        _submitVN.value = !_submitVN.value;
                        _dirtyVN.value = true;
                      },
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: _buildRouteWidget(),
                builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  if(snapshot.hasData) {
                    return ValueListenableBuilder(
                      valueListenable: _dirtyVN,
                      builder: (BuildContext context, value, Widget child) {
                        if (_dirtyVN.value) return CardTile(title: CircularProgressIndicator());
                        return snapshot.data;
                      },
                    );
                  }
                  if(snapshot.hasError) return Text(snapshot.error.toString());
                  return CircularProgressIndicator();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  double _getActualSecurityStatus(int id, double normal) {
    for(InvadedSolarSystemInformation info in _invadedSolarSystemInformation)
      if(info.systemId == id)
        return info.derivedSecurityStatus == null ? normal : double.parse(info.derivedSecurityStatus);
    return normal;
  }

  Future<Widget> _buildRouteWidget() async {
    if (!_dirtyVN.value)
      return _cached;

    if (_invadedSolarSystemInformation == null)
      _invadedSolarSystemInformation = await Kybernaut.getInvadedSolarSystemInformation();

    final origin = await context.read<SearchApi>().getSolarSystemId(_originTEC.text);
    final destination = await context.read<SearchApi>().getSolarSystemId(_destinationTEC.text);
    if (origin == -1 || destination == -1)
      return CardTile(title: Text('Error'), subtitle: Text('Invalid System Name(s)'));

    List<int> route = await context.read<RoutesApi>().getRouteWithFlag(origin, destination, _flagVN.value);
    if (route.length == 0)
      return CardTile(title: Text('Error'), subtitle: Text('No Route Found'));

    List<Widget> squares = [];
    for(int solarSystem in route)
      squares.add(
        FutureBuilder(
          future: context.read<Cache>().getSolarSystemInformation(solarSystem),
          builder: (BuildContext context, AsyncSnapshot<SolarSystemInformation> snapshot) {
            if (snapshot.hasData) {
              final actualSecurityStatus = _getActualSecurityStatus(snapshot.data.systemId, snapshot.data.securityStatus);
              return Padding(
                padding: const EdgeInsets.all(2),
                child: InkWell(
                  child: Container(
                    width: 12,
                    height: 12,
                    color: _securityStatusGradient.evaluate(
                        (actualSecurityStatus + 1) / 2),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                        AlertDialog(
                          title: Row(
                            children: [
                              Text(snapshot.data.name),
                              SizedBox(width: 4),
                              actualSecurityStatus == snapshot.data.securityStatus ? Container() : SizedBox(
                                width: 32,
                                height: 32,
                                child: Image.asset('assets/Icons/UI/WindowIcons/triglavians.png', color: Colors.black, fit: BoxFit.fill),
                              ),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Security Status'),
                                  Text(actualSecurityStatus.toStringAsFixed(2)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Stargates'),
                                  Text(snapshot.data.stargates.length
                                      .toString()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Stations'),
                                  Text(snapshot.data.stations.length
                                      .toString()),
                                ],
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: Text('Okay'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      barrierDismissible: true,
                    );
                  },
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(2),
              child: InkWell(
                child: Container(
                  width: 12,
                  height: 12,
                  color: Colors.grey,
                ),
                onTap: () {},
              ),
            );
          },
          //Universe.getSolarSystemInformation(solarSystem)

        ),
      );

    _dirtyVN.value = false;

    return CardTile(
      title: Row(
        children: [
          FutureBuilder(
            future: context.read<Cache>().getSolarSystemInformation(route[0]),
            builder: (BuildContext context, AsyncSnapshot<SolarSystemInformation> snapshot) {
              if (snapshot.hasData) return Text(snapshot.data.name);
              return Text('Loading');},
          ),
          Text(' > '),
          FutureBuilder(
            future: context.read<Cache>().getSolarSystemInformation(route[route.length - 1]),
            builder: (BuildContext context, AsyncSnapshot<SolarSystemInformation> snapshot) {
              if (snapshot.hasData) return Text(snapshot.data.name);
              return Text('Loading');},
          ),
          Text(' (${route.length - 1} Jumps)'),
        ],
      ),
      subtitle: Wrap(
        children: squares,
      ),
    );
  }
}