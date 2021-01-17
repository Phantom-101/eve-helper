import 'package:eve_helper/data_structures/local/pi_schematic.dart';
import 'package:eve_helper/helpers/esi/search.dart';
import 'package:eve_helper/helpers/esi/universe.dart';
import 'package:eve_helper/helpers/evemarketer/evemarketer.dart';
import 'package:eve_helper/helpers/local/local.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PIToolView extends StatefulWidget {
  PIToolView({Key key}) : super(key: key);

  @override
  _PIToolViewState createState() => _PIToolViewState();
}

class _PIToolViewState extends State<PIToolView> {
  Future<List<PISchematic>> _schematics;

  List<TextEditingController> _schematicTECs = [];

  Map<int, double> _income = {};
  Map<int, double> _expense = {};
  Map<int, double> _balance = {};

  ValueNotifier<bool> _dirtyVN;

  Future<int> _marketId;

  NumberFormat _formatter = NumberFormat('#,##0.00');

  @override
  void initState() {
    super.initState();

    _schematics = Local.getPISchematics();

    _dirtyVN = ValueNotifier<bool> (false);

    _marketId = Search.getSolarSystemId('Jita');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PI'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _getSchematicsCard(),
          _getBalanceCard(),
        ],
      ),
    );
  }

  Widget _getSchematicsCard() {
    return CardTile(
      title: Text('Schematics'),
      subtitle: FutureBuilder(
        future: _schematics,
        builder: (BuildContext context, AsyncSnapshot<List<PISchematic>> snapshot) {
          if (snapshot.hasData) {
            _schematicTECs = [];
            snapshot.data.forEach((schematic) {
              _schematicTECs.add(TextEditingController());
            });
            List<DataRow> rows = [];
            snapshot.data.forEach((schematic) {
              rows.add(DataRow(
                cells: [
                  DataCell(
                    Text(schematic.name),
                  ),
                  DataCell(
                    Container(
                      height: 20,
                      child: TextFormField(
                        controller: _schematicTECs[snapshot.data.indexOf(schematic)],
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _recalculate();
                        },
                      ),
                    ),
                  ),
                ]
              ));
            });
            return DataTable(
              columns: [
                DataColumn(label: Text('Schematic')),
                DataColumn(label: Text('Count')),
              ],
              rows: rows,
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _getBalanceCard() {
    return CardTile(
      title: Text('Balance'),
      subtitle: ValueListenableBuilder(
        valueListenable: _dirtyVN,
        builder: (BuildContext context, bool value, Widget child) {
          if (value) {
            return CircularProgressIndicator();
          }
          List<DataRow> rows = [];
          _balance.keys.forEach((id) {
            rows.add(DataRow(
              cells: [
                DataCell(
                  Container(
                    height: 32,
                    width: 32,
                    child: Image.network('https://images.evetech.net/types/$id/icon'),
                  )
                ),
                DataCell(
                  FutureBuilder(
                    future: Universe.getName(id),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data);
                      }
                      return Text('Loading');
                    },
                  ),
                ),
                DataCell(Text('${_formatter.format(_income[id]??0)}')),
                DataCell(Text('${_formatter.format(_expense[id]??0)}')),
                DataCell(Text('${_formatter.format(_balance[id]??0)}')),
                DataCell(
                  FutureBuilder(
                    future: _marketId,
                    builder: (BuildContext context, AsyncSnapshot<int> system) {
                      if (system.hasData) {
                        return FutureBuilder(
                          future: EveMarketer.getMinSellPrice(id, system.data),
                          builder: (BuildContext context, AsyncSnapshot<double> price) {
                            if (price.hasData) {
                              return Text('${_formatter.format(price.data * _balance[id]??0)}');
                            }
                            return Text('Loading');
                          },
                        );
                      }
                      return Text('Loading');
                    },
                  ),
                ),
              ]
            ));
          });
          return DataTable(
            columns: [
              DataColumn(label: Text('Icon')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Income')),
              DataColumn(label: Text('Expense')),
              DataColumn(label: Text('Balance')),
              DataColumn(label: Text('Profit')),
            ],
            rows: rows,
          );
        },
      ),
    );
  }

  void _recalculate() async {
    _dirtyVN.value = true;

    final schematics = await _schematics;

    _income = {};
    _expense = {};
    _balance = {};

    _schematicTECs.forEach((tec) {
      if (int.tryParse(tec.text) != null) {
        final index = _schematicTECs.indexOf(tec);
        schematics[index].inputs.forEach((input) {
          _expense[input.id] ??= 0;
          _expense[input.id] -= input.quantity * int.parse(tec.text) / schematics[index].cycleTime * 3600;
        });
        schematics[index].outputs.forEach((output) {
          _income[output.id] ??= 0;
          _income[output.id] += output.quantity * int.parse(tec.text) / schematics[index].cycleTime * 3600;
        });
      }
    });
    _income.keys.forEach((id) {
      _balance[id] ??= 0;
      _balance[id] += _income[id];
    });
    _expense.keys.forEach((id) {
      _balance[id] ??= 0;
      _balance[id] += _expense[id];
    });

    _dirtyVN.value = false;
  }
}
