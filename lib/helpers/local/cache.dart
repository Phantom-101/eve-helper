import 'package:eve_helper/data_structures/esi/locations/station_information.dart';
import 'package:eve_helper/data_structures/esi/locations/structure_information.dart';
import 'package:eve_helper/data_structures/esi/market/market_history.dart';
import 'package:eve_helper/data_structures/esi/market/market_order.dart';
import 'package:eve_helper/data_structures/esi/market/market_stats.dart';
import 'package:eve_helper/helpers/esi/market.dart';
import 'package:eve_helper/helpers/esi/search.dart';
import 'package:eve_helper/helpers/esi/universe.dart';
import 'package:eve_helper/helpers/evemarketer/evemarketer.dart';
import 'package:tuple/tuple.dart';

class Cache {
  static Map<String, Tuple2<DateTime, int>> _itemNameToId = {};
  static Map<int, Tuple2<DateTime, String>> _itemIdToName = {};
  static Map<String, Tuple2<DateTime, int>> _systemNameToId = {};
  static Map<String, Tuple2<DateTime, int>> _regionNameToId = {};
  static Map<Tuple2<int, int>, Tuple2<DateTime, MarketStats>> _systemMarketStats = {};
  static Map<Tuple2<int, int>, Tuple2<DateTime, List<MarketHistory>>> _marketHistory = {};
  static Map<Tuple2<int, int>, Tuple2<DateTime, List<MarketOrder>>> _marketOrders = {};
  static Map<int, Tuple2<DateTime, StationInformation>> _stationIdToInfo = {};
  static Map<int, Tuple2<DateTime, StructureInformation>> _structureIdToInfo = {};

  static Future<int> getItemId (String name) async {
    var now = DateTime.now();
    if (!_itemNameToId.containsKey(name) || _itemNameToId[name].item1.difference(now).inMinutes > 60)
      _itemNameToId[name] = Tuple2(now, await Search.getInventoryTypeId(name, strict: true));
    return _itemNameToId[name].item2;
  }

  static Future<String> getItemName (int id) async {
    var now = DateTime.now();
    if (!_itemIdToName.containsKey(id) || _itemIdToName[id].item1.difference(now).inMinutes > 60)
      _itemIdToName[id] = Tuple2(now, await Universe.getName(id));
    return _itemIdToName[id].item2;
  }

  static Future<int> getSolarSystemId (String name) async {
    var now = DateTime.now();
    if (!_systemNameToId.containsKey(name) || _systemNameToId[name].item1.difference(now).inMinutes > 60)
      _systemNameToId[name] = Tuple2(now, await Search.getSolarSystemId(name, strict: true));
    return _systemNameToId[name].item2;
  }

  static Future<int> getRegionId (String name) async {
    var now = DateTime.now();
    if (!_regionNameToId.containsKey(name) || _regionNameToId[name].item1.difference(now).inMinutes > 60)
      _regionNameToId[name] = Tuple2(now, await Search.getRegionId(name, strict: true));
    return _regionNameToId[name].item2;
  }

  static Future<MarketStats> getMarketStats (int systemId, int typeId) async {
    var pair = Tuple2(systemId, typeId);
    var now = DateTime.now();
    if (!_systemMarketStats.containsKey(pair) || _systemMarketStats[pair].item1.difference(now).inMinutes > 5)
      _systemMarketStats[pair] = Tuple2(now, await EveMarketer.getMarketStats(typeId, systemId));
    return _systemMarketStats[pair].item2;
  }

  static Future<List<MarketHistory>> getMarketHistory (int regionId, int typeId) async {
    var pair = Tuple2(regionId, typeId);
    var now = DateTime.now();
    if (!_marketHistory.containsKey(pair) || _marketHistory[pair].item1.difference(now).inMinutes > 5)
      _marketHistory[pair] = Tuple2(now, await Market.getMarketHistory(typeId, regionId));
    return _marketHistory[pair].item2;
  }

  static Future<List<MarketOrder>> getMarketOrders (int regionId, int typeId) async {
    var pair = Tuple2(regionId, typeId);
    var now = DateTime.now();
    if (!_marketOrders.containsKey(pair) || _marketOrders[pair].item1.difference(now).inMinutes > 5)
      _marketOrders[pair] = Tuple2(now, await Market.getMarketOrders(typeId, regionId));
    return _marketOrders[pair].item2;
  }

  static Future<StationInformation> getStationInformation (int id) async {
    var now = DateTime.now();
    if (!_stationIdToInfo.containsKey(id) || _stationIdToInfo[id].item1.difference(now).inMinutes > 60)
      _stationIdToInfo[id] = Tuple2(now, await Universe.getStationInformation(id));
    return _stationIdToInfo[id].item2;
  }

  static Future<StructureInformation> getStructureInformation (int id) async {
    var now = DateTime.now();
    if (!_structureIdToInfo.containsKey(id) || _structureIdToInfo[id].item1.difference(now).inMinutes > 10)
      _structureIdToInfo[id] = Tuple2(now, await Universe.getStructureInformation(id));
    return _structureIdToInfo[id].item2;
  }
}