import 'dart:async';
import 'package:eve_helper/data_structures/esi/locations/station_information.dart';
import 'package:eve_helper/data_structures/esi/market/market_order.dart';
import 'package:eve_helper/data_structures/esi/type_information.dart';
import 'package:eve_helper/helpers/local/cache.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:eve_helper/widgets/progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SellsBelowJitaBuyToolView extends StatefulWidget {
  SellsBelowJitaBuyToolView({Key key}) : super(key: key);

  @override
  _SellsBelowJitaBuyToolViewState createState() => _SellsBelowJitaBuyToolViewState();
}

class _SellsBelowJitaBuyToolViewState extends State<SellsBelowJitaBuyToolView> {
  TextEditingController _systemTEC = TextEditingController(text: '');
  TextEditingController _percentTEC = TextEditingController(text: '0.88');
  TextEditingController _salesTaxTEC = TextEditingController(text: '0.05');
  ValueNotifier<String> _systemVN = ValueNotifier('');
  ValueNotifier<double> _percentVN = ValueNotifier(0.88);
  ValueNotifier<double> _salesTaxVN = ValueNotifier(0.05);
  Progress _getSystemId = Progress();
  Progress _getRegionId = Progress();
  Progress _getRegionOrders = Progress();
  Progress _filterSystemOrders = Progress();
  Progress _filterBelowPercent = Progress();
  int _jobIndex = 0;
  int _activeJobs = 0;
  Completer _jobComplete = Completer();
  ValueNotifier<_DataSource> _dataSource = ValueNotifier(_DataSource(<DataGridRow>[]));
  //NumberFormat _formatter = NumberFormat('#,##0.00');

  @override
  void dispose() {
    super.dispose();
    _systemTEC.dispose();
    _percentTEC.dispose();
    _systemVN.dispose();
    _percentVN.dispose();
    _dataSource.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sells Below Jita Buy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StaggeredGridView.count(
          crossAxisCount: 4,
          children: [
            CardTile(
              title: Text('Parameters'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text('Solar System Name'),
                  TextFormField(
                    controller: _systemTEC,
                  ),
                  SizedBox(height: 8),
                  Text('Percent'),
                  TextFormField(
                    controller: _percentTEC,
                  ),
                  SizedBox(height: 8),
                  Text('Sales Tax'),
                  TextFormField(
                    controller: _salesTaxTEC,
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    child: Text('Submit'),
                    onPressed: () {
                      _systemVN.value = _systemTEC.text;
                      _percentVN.value = double.tryParse(_percentTEC.text) ?? 0.88;
                      _salesTaxVN.value = double.tryParse(_salesTaxTEC.text) ?? 0.05;
                      _onSubmit();
                    },
                  ),
                ],
              ),
            ),
            CardTile(
              title: Text('Query Status'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Get Solar System Id'),
                      SizedBox(width: 8),
                      _getSystemId.getWidget(12),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Get Region Id'),
                      SizedBox(width: 8),
                      _getRegionId.getWidget(12),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Get Region Orders'),
                      SizedBox(width: 8),
                      _getRegionOrders.getWidget(12),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Filter System Orders'),
                      SizedBox(width: 8),
                      _filterSystemOrders.getWidget(12),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Filter Below Percent'),
                      SizedBox(width: 8),
                      _filterBelowPercent.getWidget(12),
                    ],
                  ),
                ],
              ),
            ),
            CardTile(
              title: Text('Note'),
              subtitle: Text('This tool is by no means 100% accurate. It does not take the buy volume at Jita into account, nor does it buy orders which are not in Jita but has a range extending into Jita. Use this tool with care.'),
            ),
            Divider(
              color: Colors.blueGrey[100],
              height: 32,
              thickness: 1,
            ),
            ValueListenableBuilder(
              valueListenable: _dataSource,
              builder: (context, dataSource, child) {
                return ValueListenableBuilder(
                  valueListenable: _salesTaxVN,
                  builder: (context, tax, child) {
                    return CardTile(
                      title: Text('Results'),
                      subtitle: Container(
                        height: 500,
                        child: SfDataGrid(
                          source: _dataSource.value,
                          columnWidthMode: ColumnWidthMode.fill,
                          headerRowHeight: 50,
                          rowHeight: 100,
                          isScrollbarAlwaysShown: true,
                          allowSorting: true,
                          allowTriStateSorting: true,
                          columns: [
                            GridTextColumn(columnName: 'name', label: Padding(child: Text('Name'), padding: const EdgeInsets.all(16))),
                            GridTextColumn(columnName: 'price', label: Padding(child: Text('Price'), padding: const EdgeInsets.all(16))),
                            GridTextColumn(columnName: 'order-volume', label: Padding(child: Text('Order Volume'), padding: const EdgeInsets.all(16))),
                            GridTextColumn(columnName: 'location', label: Padding(child: Text('Location'), padding: const EdgeInsets.all(16))),
                            GridTextColumn(columnName: 'jita-max-buy', label: Padding(child: Text('Jita Max Buy'), padding: const EdgeInsets.all(16))),
                            GridTextColumn(columnName: 'profit', label: Padding(child: Text('Profit'), padding: const EdgeInsets.all(16))),
                            GridTextColumn(columnName: 'total-profit', label: Padding(child: Text('Total Profit'), padding: const EdgeInsets.all(16))),
                            GridTextColumn(columnName: 'item-volume', label: Padding(child: Text('Item Volume'), padding: const EdgeInsets.all(16))),
                            GridTextColumn(columnName: 'item-total-volume', label: Padding(child: Text('Item Total Volume'), padding: const EdgeInsets.all(16))),
                            GridTextColumn(columnName: 'profit-per-volume', label: Padding(child: Text('Profit Per Volume'), padding: const EdgeInsets.all(16))),
                          ],
                        ),
                      ),
                    );
                  }
                );
              },
            ),
          ],
          staggeredTiles: [
            StaggeredTile.fit(2),
            StaggeredTile.fit(2),
            StaggeredTile.fit(2),
            StaggeredTile.fit(4),
            StaggeredTile.fit(4),
          ],
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          padding: const EdgeInsets.all(4.0),
        ),
      ),
    );
  }

  void _onSubmit() async {
    var systemId;
    try {
      _getSystemId.start(1);
      systemId = await context.read<Cache>().getSolarSystemId(_systemVN.value);
      _getSystemId.progress.value++;
      var systemInfo, constellationInfo;
      try {
        _getRegionId.start(2);
        systemInfo = await context.read<Cache>().getSolarSystemInformation(systemId);
        _getRegionId.progress.value++;
        constellationInfo = await context.read<Cache>().getConstellationInformation(systemInfo.constellationId);
        _getRegionId.progress.value++;
        var regionOrders;
        try {
          _getRegionOrders.start(1);
          regionOrders = await context.read<Cache>().getMarketSellOrders(constellationInfo.regionId);
          _getRegionOrders.progress.value++;
          final systemFiltered = <MarketOrder>[];
          _filterSystemOrders.start(regionOrders.length);
          _jobIndex = 0;
          _jobComplete = Completer();
          for (int i = 0; i < 100; i++) {
            _activeJobs++;
            _filterSystemOrdersJob(regionOrders, systemFiltered, systemId);
          }
          await _jobComplete.future;
          final jitaFiltered = <DataGridRow>[];
          _filterBelowPercent.start(systemFiltered.length);
          _jobIndex = 0;
          _jobComplete = Completer();
          for (int i = 0; i < 100; i++) {
            _activeJobs++;
            _filterBelowPercentJob(systemFiltered, jitaFiltered);
          }
          await _jobComplete.future;
          _dataSource.value = _DataSource(jitaFiltered);
        } catch(e) {
          print(e);
          _getRegionOrders.err();
        }
      } catch(e) {
        print(e);
        _getRegionId.err();
      }
    } catch(e) {
      print(e);
      _getSystemId.err();
    }
  }

  void _filterSystemOrdersJob(List<MarketOrder> input, List<MarketOrder> output, int systemId) async {
    if (_jobIndex >= input.length) {
      _activeJobs--;
      if (_activeJobs == 0) _jobComplete.complete();
      return;
    }
    MarketOrder assigned = input[_jobIndex];
    _jobIndex++;
    try {
      if (assigned.locationId < 1000000000) {
        var locationInfo = await context.read<Cache>().getStationInformation(assigned.locationId);
        if (locationInfo.systemId == systemId) {
          output.add(assigned);
        }
      }
    } catch(e) {
      print(e);
    }
    _filterSystemOrders.progress.value++;
    _filterSystemOrdersJob(input, output, systemId);
  }

  void _filterBelowPercentJob(List<MarketOrder> input, List<DataGridRow> output) async {
    if (_jobIndex >= input.length) {
      _activeJobs--;
      if (_activeJobs == 0) _jobComplete.complete();
      return;
    }
    MarketOrder assigned = input[_jobIndex];
    _jobIndex++;
    try {
      double jita = await _getJitaMaxBuy(assigned.typeId);
      if (assigned.price < jita * _percentVN.value) {
        TypeInformation info = await context.read<Cache>().getItemInformation(assigned.typeId);
        StationInformation loc = await context.read<Cache>().getStationInformation(assigned.locationId);
        double profit = jita * (1 - _salesTaxVN.value) - assigned.price;
        output.add(DataGridRow(
          cells: [
            DataGridCell<String>(columnName: 'name', value: info.name),
            DataGridCell<double>(columnName: 'price', value: assigned.price),
            DataGridCell<int>(columnName: 'order-volume', value: assigned.volumeRemain),
            DataGridCell<String>(columnName: 'location', value: loc.name),
            DataGridCell<double>(columnName: 'jita-max-buy', value: jita),
            DataGridCell<double>(columnName: 'profit', value: profit),
            DataGridCell<double>(columnName: 'total-profit', value: profit * assigned.volumeRemain),
            DataGridCell<double>(columnName: 'item-volume', value: info.volume),
            DataGridCell<double>(columnName: 'item-total-volume', value: info.volume * assigned.volumeRemain),
            DataGridCell<double>(columnName: 'profit-per-volume', value: profit / info.volume),
          ],
        ));
      }
    } catch(e) {
      print(e);
    }
    _filterBelowPercent.progress.value++;
    _filterBelowPercentJob(input, output);
  }

  Future<double> _getJitaMaxBuy (int typeId) async {
    int forgeId = await context.read<Cache>().getRegionId('The Forge');
    int jitaId = await context.read<Cache>().getSolarSystemId('Jita');
    var itemOrders = await context.read<Cache>().getItemMarketBuyOrders(forgeId, typeId);
    double max = 0;
    for(MarketOrder itemOrder in itemOrders){
      if (itemOrder.price > max) {
        try {
          if (itemOrder.locationId < 1000000000) {
            var locationInfo = await context.read<Cache>().getStationInformation(itemOrder.locationId);
            if (locationInfo.systemId == jitaId) {
              max = itemOrder.price;
            }
          }
        } catch(e) {
          print(e);
          return 0;
        }
      }
    }
    return max;
  }
}

class _DataSource extends DataGridSource {
  List<DataGridRow> r;
  @override
  List<DataGridRow> get rows => r;

  _DataSource(this.r);

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Wrap(
            children: [
              Text(e.value.toString(), overflow: TextOverflow.fade),
            ],
          ),
        );
      }).toList(),
    );
  }
}