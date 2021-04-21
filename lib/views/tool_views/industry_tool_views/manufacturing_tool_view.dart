import 'dart:math';
import 'package:eve_helper/data_structures.dart';
import 'package:eve_helper/data_structures/esi/industry/solar_system_cost_indices.dart';
import 'package:eve_helper/data_structures/esi/market/aa_prices.dart';
import 'package:eve_helper/data_structures/esi/market/market_stats.dart';
import 'package:eve_helper/helpers.dart';
import 'package:eve_helper/helpers/esi/industry_api.dart';
import 'package:eve_helper/helpers/esi/market_api.dart';
import 'package:eve_helper/helpers/esi/search_api.dart';
import 'package:eve_helper/helpers/local/cache.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ManufacturingToolView extends StatefulWidget {
  ManufacturingToolView({Key key}) : super(key: key);

  @override
  _ManufacturingToolViewState createState() => _ManufacturingToolViewState();
}

class _ManufacturingToolViewState extends State<ManufacturingToolView> {
  TextEditingController _blueprintTEC;
  TextEditingController _marketTEC;
  TextEditingController _industryTEC;

  ValueNotifier<BlueprintInformation> _blueprintInformationVN;
  ValueNotifier<bool> _dirtyVN;

  ValueNotifier<double> _meVN;
  ValueNotifier<double> _teVN;
  ValueNotifier<int> _runsVN;

  ValueNotifier<int> _brokerFeeVN;
  ValueNotifier<int> _salesTaxVN;

  Future<int> _marketSystemId;
  Future<int> _industrySystemId;
  List<Future<MarketStats>> _prices;
  Future<MarketStats> _productPrice;

  Future<List<AAPrices>> _aaPrices;
  Future<List<SolarSystemCostIndices>> _costIndices;

  NumberFormat _formatter = NumberFormat('#,##0.00');

  @override
  void initState() {
    super.initState();

    _blueprintTEC = TextEditingController();
    _marketTEC = TextEditingController(text: 'Jita');
    _industryTEC = TextEditingController(text: 'Jita');

    _blueprintInformationVN = ValueNotifier<BlueprintInformation>(null);
    _dirtyVN = ValueNotifier<bool>(false);

    _meVN = ValueNotifier<double>(0);
    _teVN = ValueNotifier<double>(0);
    _runsVN = ValueNotifier<int>(1);

    _brokerFeeVN = ValueNotifier<int>(5);
    _salesTaxVN = ValueNotifier<int>(5);

    _aaPrices = context.read<MarketApi>().getAAPrices();
    _costIndices = context.read<IndustryApi>().getSolarSystemCostIndices();

    _marketSystemId = context.read<SearchApi>().getSolarSystemId('Jita', strict: true);
    _industrySystemId = context.read<SearchApi>().getSolarSystemId('Jita', strict: true);
  }

  @override
  void dispose() {
    super.dispose();

    _blueprintTEC.dispose();

    _blueprintInformationVN.dispose();
    _dirtyVN.dispose();

    _meVN.dispose();
    _teVN.dispose();
    _runsVN.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manufacturing'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          CardTile(
            title: Text('Blueprint Selection'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text('Product Name'),
                TextFormField(
                  controller: _blueprintTEC,
                ),
                SizedBox(height: 8),
                Text('Market System'),
                TextFormField(
                  controller: _marketTEC,
                ),
                SizedBox(height: 8),
                Text('Industry System'),
                TextFormField(
                  controller: _industryTEC,
                ),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: _submit,
                ),
              ],
            ),
          ),
          CardTile(
            title: Text('Blueprint Details'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: _meVN,
                  builder: (BuildContext context, value, Widget child) {
                    return Row(
                      children: [
                        Text('Material Efficiency'),
                        Slider(
                          value: _meVN.value,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: 'ME: ${_meVN.value.toStringAsFixed(0)}',
                          onChanged: (value) {
                            _meVN.value = value;
                          },
                        ),
                        Text(_meVN.value.toStringAsFixed(0)),
                      ],
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: _teVN,
                  builder: (BuildContext context, value, Widget child) {
                    return Row(
                      children: [
                        Text('Time Efficiency'),
                        Slider(
                          value: _teVN.value,
                          min: 0,
                          max: 20,
                          divisions: 10,
                          label: 'TE: ${_teVN.value.toStringAsFixed(0)}',
                          onChanged: (value) {
                            _teVN.value = value;
                          },
                        ),
                        Text(_teVN.value.toStringAsFixed(0)),
                      ],
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: _runsVN,
                  builder: (BuildContext context, value, Widget child) {
                    return Row(
                      children: [
                        Text('Runs'),
                        SizedBox(width: 8),
                        Container(
                          width: 200,
                          child: TextFormField(
                            initialValue: _runsVN.value.toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _runsVN.value = int.parse(value);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          CardTile(
            title: Text('Character Details'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: _brokerFeeVN,
                  builder: (BuildContext context, value, Widget child) {
                    return Row(
                      children: [
                        Text('Broker Fees %'),
                        SizedBox(width: 8),
                        Container(
                          width: 200,
                          child: TextFormField(
                            initialValue: _brokerFeeVN.value.toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _brokerFeeVN.value = int.parse(value);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: _salesTaxVN,
                  builder: (BuildContext context, value, Widget child) {
                    return Row(
                      children: [
                        Text('Sales Tax %'),
                        SizedBox(width: 8),
                        Container(
                          width: 200,
                          child: TextFormField(
                            initialValue: _salesTaxVN.value.toString(),
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (value) {
                              _salesTaxVN.value = int.parse(value);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          _buildOverviewCard(),
          _buildMaterialsCard(),
          _buildPricesCard(),
          _buildFeesCard(),
          _buildCalculationsCard(),
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
    return ValueListenableBuilder(
      valueListenable: _dirtyVN,
      builder: (BuildContext context, value, Widget child) {
        if (_dirtyVN.value) return CardTile(title: CircularProgressIndicator());
        return ValueListenableBuilder(
          valueListenable: _blueprintInformationVN,
          builder: (BuildContext context, value, Widget child) {
            if (_blueprintInformationVN.value == null) return Container();
            return CardTile(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    child: Image.network('https://images.evetech.net/types/${_blueprintInformationVN.value.details.productTypeId}/icon'),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_blueprintInformationVN.value.details.productTypeName),
                          SizedBox(height: 2),
                          FutureBuilder(
                            future: _productPrice,
                            builder: (context, price) {
                              if (price.hasData) {
                                return Text('Jita Min Sell Price: ${_formatter.format(price.data.minSell)}');
                              }
                              return Text('Jita Min Sell Price: Loading');
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: _teVN,
                            builder: (BuildContext context, double value, Widget child) {
                              return Text('Time Per Run: ${_formatDuration(Duration(seconds: _getTimePerRun().toInt()))}');
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: _teVN,
                            builder: (BuildContext context, double value, Widget child) {
                              return ValueListenableBuilder(
                                valueListenable: _runsVN,
                                builder: (BuildContext context, int value, Widget child) {
                                  return Text('Total Time: ${_formatDuration(Duration(seconds: _getTotalTime().toInt()))}');
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMaterialsCard() {
    return ValueListenableBuilder(
      valueListenable: _dirtyVN,
      builder: (BuildContext context, value, Widget child) {
        if (_dirtyVN.value) return CardTile(title: CircularProgressIndicator());
        return ValueListenableBuilder(
          valueListenable: _blueprintInformationVN,
          builder: (BuildContext context, value, Widget child) {
            if (_blueprintInformationVN.value == null) return Container();
            List<DataRow> rows = [];
            _blueprintInformationVN.value.activityMaterials.manufacture.forEach((info) => {
              rows.add(
                DataRow(
                  cells: [
                    DataCell(
                      Container(
                        height: 32,
                        width: 32,
                        child: Image.network('https://images.evetech.net/types/${info.typeId}/icon'),
                      ),
                    ),
                    DataCell(Text(info.name)),
                    DataCell(
                      ValueListenableBuilder(
                        valueListenable: _meVN,
                        builder: (BuildContext context, value, Widget child) {
                          return ValueListenableBuilder(
                              valueListenable: _runsVN,
                              builder: (BuildContext context, value, Widget child) {
                                return Text('${_getQuantity(info, _runsVN.value)}');
                              }
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            });
            return CardTile(
              title: Text('Materials'),
              subtitle: DataTable(
                columns: [
                  DataColumn(label: Text('Icon')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Quantity')),
                ],
                rows: rows,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPricesCard() {
    return ValueListenableBuilder(
      valueListenable: _dirtyVN,
      builder: (BuildContext context, value, Widget child) {
        if (_dirtyVN.value) return CardTile(title: CircularProgressIndicator());
        return ValueListenableBuilder(
          valueListenable: _blueprintInformationVN,
          builder: (BuildContext context, value, Widget child) {
            if (_blueprintInformationVN.value == null) return Container();
            List<DataRow> rows = [];
            _blueprintInformationVN.value.activityMaterials.manufacture.forEach((info) => {
              rows.add(
                DataRow(
                  cells: [
                    DataCell(
                      Container(
                        height: 32,
                        width: 32,
                        child: Image.network('https://images.evetech.net/types/${info.typeId}/icon'),
                      ),
                    ),
                    DataCell(
                      FutureBuilder(
                        future: _getPrice(info, 1),
                        builder: (BuildContext context, AsyncSnapshot<double> price) {
                          if (price.hasData) {
                            return Text('${_formatter.format(price.data)}');
                          }
                          return Text('Loading');
                        },
                      ),
                    ),
                    DataCell(
                      ValueListenableBuilder(
                        valueListenable: _meVN,
                        builder: (BuildContext context, value, Widget child) {
                          return ValueListenableBuilder(
                            valueListenable: _runsVN,
                            builder: (BuildContext context, value, Widget child) {
                              return FutureBuilder(
                                future: _getPrice(info, _getQuantity(info, _runsVN.value)),
                                builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text('${_formatter.format(snapshot.data)}');
                                  }
                                  return Text('Loading');
                                },
                              );
                            }
                          );
                        },
                      )
                    ),
                  ],
                ),
              )
            });
            rows.add(
              DataRow(
                cells: [
                  DataCell(Text('Total')),
                  DataCell(Container()),
                  DataCell(
                    ValueListenableBuilder(
                      valueListenable: _meVN,
                      builder: (BuildContext context, value, Widget child) {
                        return ValueListenableBuilder(
                          valueListenable: _runsVN,
                          builder: (BuildContext context, value, Widget child) {
                            return FutureBuilder(
                              future: _getTotalPrice(),
                              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                if (snapshot.hasData) {
                                  return Text('${_formatter.format(snapshot.data)}');
                                }
                                return Text('Loading');
                              },
                            );
                          }
                        );
                      }
                    )
                  ),
                ],
              ),
            );
            return CardTile(
              title: Text('Prices'),
              subtitle: DataTable(
                columns: [
                  DataColumn(label: Text('Icon')),
                  DataColumn(label: Text('Per Unit'), tooltip: 'Cost per unit of material'),
                  DataColumn(label: Text('Total'), tooltip: 'Total cost of this material'),
                ],
                rows: rows,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFeesCard() {
    return ValueListenableBuilder(
      valueListenable: _dirtyVN,
      builder: (BuildContext context, value, Widget child) {
        if (_dirtyVN.value) return CardTile(title: CircularProgressIndicator());
        return ValueListenableBuilder(
          valueListenable: _blueprintInformationVN,
          builder: (BuildContext context, value, Widget child) {
            if (_blueprintInformationVN.value == null) return Container();
            return CardTile(
              title: Text('Fees'),
              subtitle: DataTable(
                columns: [
                  DataColumn(label: Text('Variable')),
                  DataColumn(label: Text('1 run')),
                  DataColumn(label: Text('Input runs')),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text('Job Base Cost')),
                      DataCell(
                        FutureBuilder(
                          future: _getJobBaseCost(),
                          builder: (BuildContext context, AsyncSnapshot<double> base) {
                            if (base.hasData) {
                              return Text('${_formatter.format(base.data)}');
                            }
                            return Text('Loading');
                          },
                        ),
                      ),
                      DataCell(
                        FutureBuilder(
                          future: _getJobBaseCost(),
                          builder: (BuildContext context, AsyncSnapshot<double> base) {
                            if (base.hasData) {
                              return ValueListenableBuilder(
                                valueListenable: _runsVN,
                                builder: (BuildContext context, int value, Widget child) {
                                  return Text('${_formatter.format(base.data * _runsVN.value)}');
                                },
                              );
                            }
                            return Text('Loading');
                          },
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Job Fee')),
                      DataCell(
                        FutureBuilder(future: _getJobFee(1),
                          builder: (BuildContext context, AsyncSnapshot<double> fee) {
                            if (fee.hasData) {
                              return Text('${_formatter.format(fee.data)}');
                            }
                            return Text('Loading');
                          },
                        )
                      ),
                      DataCell(
                        ValueListenableBuilder(
                          valueListenable: _runsVN,
                          builder: (BuildContext context, int value, Widget child) {
                            return FutureBuilder(
                              future: _getJobFee(_runsVN.value),
                              builder: (BuildContext context, AsyncSnapshot<double> fee) {
                                if (fee.hasData) {
                                  return Text('${_formatter.format(fee.data)}');
                                }
                                return Text('Loading');
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Broker Fees')),
                      DataCell(
                        ValueListenableBuilder(
                          valueListenable: _brokerFeeVN,
                          builder: (BuildContext context, int value, Widget child) {
                            return FutureBuilder(
                              future: _getBrokerFeesIncreasePerRun(),
                              builder: (BuildContext context, AsyncSnapshot<double> increase) {
                                if (increase.hasData) {
                                  return Text('${_formatter.format(increase.data)}');
                                }
                                return Text('Loading');
                              },
                            );
                          },
                        ),
                      ),
                      DataCell(
                        ValueListenableBuilder(
                          valueListenable: _brokerFeeVN,
                          builder: (BuildContext context, int value, Widget child) {
                            return FutureBuilder(
                              future: _getBrokerFeesIncrease(),
                              builder: (BuildContext context, AsyncSnapshot<double> increase) {
                                if (increase.hasData) {
                                  return Text('${_formatter.format(increase.data)}');
                                }
                                return Text('Loading');
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Sales Tax')),
                      DataCell(
                        ValueListenableBuilder(
                          valueListenable: _salesTaxVN,
                          builder: (BuildContext context, int value, Widget child) {
                            return FutureBuilder(
                              future: _getSalesTaxIncreasePerRun(),
                              builder: (BuildContext context, AsyncSnapshot<double> increase) {
                                if (increase.hasData) {
                                  return Text('${_formatter.format(increase.data)}');
                                }
                                return Text('Loading');
                              },
                            );
                          },
                        ),
                      ),
                      DataCell(
                        ValueListenableBuilder(
                          valueListenable: _salesTaxVN,
                          builder: (BuildContext context, int value, Widget child) {
                            return FutureBuilder(
                              future: _getSalesTaxIncrease(),
                              builder: (BuildContext context, AsyncSnapshot<double> increase) {
                                if (increase.hasData) {
                                  return Text('${_formatter.format(increase.data)}');
                                }
                                return Text('Loading');
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCalculationsCard() {
    return ValueListenableBuilder(
      valueListenable: _dirtyVN,
      builder: (BuildContext context, value, Widget child) {
        if (_dirtyVN.value) return CardTile(title: CircularProgressIndicator());
        return ValueListenableBuilder(
          valueListenable: _blueprintInformationVN,
          builder: (BuildContext context, value, Widget child) {
            if (_blueprintInformationVN.value == null) return Container();
            return CardTile(
              title: Text('Calculations'),
              subtitle: DataTable(
                columns: [
                  DataColumn(label: Text('Metric')),
                  DataColumn(label: Text('Profit')),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text('Input runs')),
                      DataCell(
                        ValueListenableBuilder(
                          valueListenable: _brokerFeeVN,
                          builder: (BuildContext context, value, Widget child) {
                            return ValueListenableBuilder(
                              valueListenable: _salesTaxVN,
                              builder: (BuildContext context, value, Widget child) {
                                return FutureBuilder(
                                  future: _getProfitPerRun(),
                                  builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                    if (snapshot.hasData) {
                                      return Text('${_formatter.format(snapshot.data * _runsVN.value)}');
                                    }
                                    return Text('Loading');
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('1 run')),
                      DataCell(
                        ValueListenableBuilder(
                          valueListenable: _brokerFeeVN,
                          builder: (BuildContext context, value, Widget child) {
                            return ValueListenableBuilder(
                              valueListenable: _salesTaxVN,
                              builder: (BuildContext context, value, Widget child) {
                                return FutureBuilder(
                                  future: _getProfitPerRun(),
                                  builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                    if (snapshot.hasData) {
                                      return Text('${_formatter.format(snapshot.data)}');
                                    }
                                    return Text('Loading');
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('1 hour')),
                      DataCell(
                        ValueListenableBuilder(
                          valueListenable: _brokerFeeVN,
                          builder: (BuildContext context, value, Widget child) {
                            return ValueListenableBuilder(
                              valueListenable: _salesTaxVN,
                              builder: (BuildContext context, value, Widget child) {
                                return ValueListenableBuilder(
                                  valueListenable: _teVN,
                                  builder: (BuildContext context, value, Widget child) {
                                    return FutureBuilder(
                                      future: _getProfitPerRun(),
                                      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                        if (snapshot.hasData) {
                                          return Text('${_formatter.format(snapshot.data / (_getTimePerRun() / 3600))}');
                                        }
                                        return Text('Loading');
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _submit() async {
    _dirtyVN.value = true;

    final id = await context.read<SearchApi>().getInventoryTypeId(_blueprintTEC.text, strict: true);
    _blueprintInformationVN.value = await Helpers.getBlueprintInformation(id);

    List<int> ids = [];
    _blueprintInformationVN.value.activityMaterials.manufacture.forEach((material) {
      ids.add(material.typeId);
    });

    _marketSystemId = context.read<Cache>().getSolarSystemId(_marketTEC.text);
    _industrySystemId = context.read<Cache>().getSolarSystemId(_industryTEC.text);

    _prices = List.filled(ids.length, null);
    for (int i = 0; i < ids.length; i++) {
      _prices[i] = context.read<Cache>().getMarketStats(await _marketSystemId, ids[i]);
    }
    _productPrice = context.read<Cache>().getMarketStats(await _marketSystemId, _blueprintInformationVN.value.details.productTypeId);

    _dirtyVN.value = false;
  }

  int _getQuantity(BlueprintActivityMaterialInformation info, int runs) {
    return max(runs, (runs * info.quantity * (1 - _meVN.value * 0.01)).ceil());
  }

  Future<double> _getPrice(BlueprintActivityMaterialInformation material, int quantity) async {
    return (await _prices[_blueprintInformationVN.value.activityMaterials.manufacture.indexOf(material)]).minSell * quantity;
  }

  Future<double> _getTotalPrice() async {
    double total = 0;
    for(int i = 0; i < _blueprintInformationVN.value.activityMaterials.manufacture.length; i++) {
      final material = _blueprintInformationVN.value.activityMaterials.manufacture[i];
      total += await _getPrice(material, _getQuantity(material, _runsVN.value));
    }
    return total;
  }

  Future<double> _getPerRunPrice() async {
    double total = 0;
    for(int i = 0; i < _blueprintInformationVN.value.activityMaterials.manufacture.length; i++) {
      final material = _blueprintInformationVN.value.activityMaterials.manufacture[i];
      total += await _getPrice(material, _getQuantity(material, 1));
    }
    return total;
  }

  double _getTimePerRun() {
    return _blueprintInformationVN.value.details.times['1'] * (1 - _teVN.value * 0.01);
  }

  double _getTotalTime() {
    return _getTimePerRun() * _runsVN.value;
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) return '${duration.inDays}d ${duration.inHours.remainder(24)}h ${duration.inMinutes.remainder(60)}m ${duration.inSeconds.remainder(60)}s';
    if (duration.inHours > 0) return '${duration.inHours.remainder(24)}h ${duration.inMinutes.remainder(60)}m ${duration.inSeconds.remainder(60)}s';
    if (duration.inMinutes > 0) return '${duration.inMinutes.remainder(60)}m ${duration.inSeconds.remainder(60)}s';
    return '${duration.inSeconds.remainder(60)}s';
  }

  Future<double> _getJobBaseCost() async {
    List<AAPrices> aaPrices = await _aaPrices;

    double total = 0;
    _blueprintInformationVN.value.activityMaterials.manufacture.forEach((material) {
      double adjusted;
      for (AAPrices prices in aaPrices) {
        if (prices.typeId == material.typeId) {
          adjusted = prices.adjustedPrice;
          break;
        }
      }
      total += adjusted * material.quantity;
    });
    return total;
  }

  Future<double> _getJobFee(int runs) async {
    double base = await _getJobBaseCost();
    List<SolarSystemCostIndices> costIndices = await _costIndices;

    int systemId = await _industrySystemId;

    double costIndex = 0;
    for (SolarSystemCostIndices element in costIndices) {
      if (element.solarSystemId == systemId) {
        costIndex = element.manufacturing;
        break;
      }
    }

    return base * costIndex * runs;
  }

  Future<double> _getBrokerFeesIncrease() async {
    final price = await _productPrice;
    return price.minSell * _blueprintInformationVN.value.details.productQuantity * _brokerFeeVN.value * 0.01 * _runsVN.value;
  }

  Future<double> _getBrokerFeesIncreasePerRun() async {
    final price = await _productPrice;
    return price.minSell * _blueprintInformationVN.value.details.productQuantity * _brokerFeeVN.value * 0.01;
  }

  Future<double> _getSalesTaxIncrease() async {
    final price = await _productPrice;
    return price.minSell * _blueprintInformationVN.value.details.productQuantity * _salesTaxVN.value * 0.01 * _runsVN.value;
  }

  Future<double> _getSalesTaxIncreasePerRun() async {
    final price = await _productPrice;
    return price.minSell * _blueprintInformationVN.value.details.productQuantity * _salesTaxVN.value * 0.01;
  }
  
  Future<double> _getProfitPerRun() async {
    final productRevenue = (await _productPrice).minSell * _blueprintInformationVN.value.details.productQuantity;
    final materialExpenses = await _getPerRunPrice();
    final brokerFeesIncrease = await _getBrokerFeesIncreasePerRun();
    final salesTaxIncrease = await _getSalesTaxIncreasePerRun();
    final jobFee = await _getJobFee(1);
    
    return productRevenue - materialExpenses - brokerFeesIncrease - salesTaxIncrease - jobFee;
  }
}
