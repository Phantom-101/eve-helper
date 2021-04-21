import 'package:eve_helper/data_structures.dart';
import 'package:eve_helper/data_structures/esi/locations/constellation_information.dart';
import 'package:eve_helper/data_structures/esi/locations/station_information.dart';
import 'package:eve_helper/data_structures/esi/locations/structure_information.dart';
import 'package:eve_helper/data_structures/esi/market/market_history.dart';
import 'package:eve_helper/data_structures/esi/market/market_order.dart';
import 'package:eve_helper/data_structures/esi/market/market_stats.dart';
import 'package:eve_helper/data_structures/esi/type_information.dart';
import 'package:eve_helper/data_structures/local/cached_item.dart';
import 'package:eve_helper/helpers/esi/industry_api.dart';
import 'package:eve_helper/helpers/esi/market_api.dart';
import 'package:eve_helper/helpers/esi/routes_api.dart';
import 'package:eve_helper/helpers/esi/search_api.dart';
import 'package:eve_helper/helpers/esi/universe_api.dart';
import 'package:eve_helper/helpers/evemarketer/evemarketer.dart';
import 'package:tuple/tuple.dart';

class Cache {
  Map<String, CachedItem<int>> _itemNameToId = {};
  Map<int, CachedItem<String>> _itemIdToName = {};
  Map<int, CachedItem<TypeInformation>> _itemIdToInfo = {};
  Map<String, CachedItem<int>> _systemNameToId = {};
  Map<String, CachedItem<int>> _regionNameToId = {};
  Map<Tuple2<int, int>, CachedItem<MarketStats>> _systemMarketStats = {};
  Map<Tuple2<int, int>, CachedItem<List<MarketHistory>>> _marketHistory = {};
  Map<int, CachedItem<List<MarketOrder>>> _marketOrders = {};
  Map<int, CachedItem<List<MarketOrder>>> _marketBuyOrders = {};
  Map<int, CachedItem<List<MarketOrder>>> _marketSellOrders = {};
  Map<Tuple2<int, int>, CachedItem<List<MarketOrder>>> _itemMarketOrders = {};
  Map<Tuple2<int, int>, CachedItem<List<MarketOrder>>> _itemMarketBuyOrders = {};
  Map<Tuple2<int, int>, CachedItem<List<MarketOrder>>> _itemMarketSellOrders = {};
  Map<int, CachedItem<ConstellationInformation>> _constellationIdToInfo = {};
  Map<int, CachedItem<SolarSystemInformation>> _systemIdToInfo = {};
  Map<int, CachedItem<StationInformation>> _stationIdToInfo = {};
  Map<int, CachedItem<StructureInformation>> _structureIdToInfo = {};

  IndustryApi _industryApi;
  MarketApi _marketApi;
  RoutesApi _routesApi;
  SearchApi _searchApi;
  UniverseApi _universeApi;

  Cache(this._industryApi, this._marketApi, this._routesApi, this._searchApi, this._universeApi);

  Future<int> getItemId (String name) async {
    try {
      if (shouldRetrieve(_itemNameToId, name, 720)) {
        var ci = CachedItem<int>();
        ci.data = _searchApi.getInventoryTypeId(name, strict: true);
        ci.time = DateTime.now();
        _itemNameToId[name] = ci;
      }
      return await _itemNameToId[name].data;
    } catch(e) {
      throw e;
    }
  }

  Future<String> getItemName (int id) async {
    try {
      if (shouldRetrieve(_itemIdToName, id, 720)) {
        var ci = CachedItem<String>();
        ci.data = _universeApi.getName(id);
        ci.time = DateTime.now();
        _itemIdToName[id] = ci;
      }
      return await _itemIdToName[id].data;
    } catch(e) {
      throw e;
    }
  }

  Future<TypeInformation> getItemInformation (int id) async {
    try {
      if (shouldRetrieve(_itemIdToInfo, id, 720)) {
        var ci = CachedItem<TypeInformation>();
        ci.data = _universeApi.getTypeInformation(id);
        ci.time = DateTime.now();
        _itemIdToInfo[id] = ci;
      }
      return await _itemIdToInfo[id].data;
    } catch(e) {
      throw e;
    }
  }

  Future<int> getSolarSystemId (String name) async {
    try {
      if (shouldRetrieve(_systemNameToId, name, 720)) {
        var ci = CachedItem<int>();
        ci.data = _searchApi.getSolarSystemId(name, strict: true);
        ci.time = DateTime.now();
        _systemNameToId[name] = ci;
      }
      return await _systemNameToId[name].data;
    } catch(e) {
      throw e;
    }
  }

  Future<int> getRegionId (String name) async {
    try {
      if (shouldRetrieve(_regionNameToId, name, 720)) {
        var ci = CachedItem<int>();
        ci.data = _searchApi.getRegionId(name, strict: true);
        ci.time = DateTime.now();
        _regionNameToId[name] = ci;
      }
      return await _regionNameToId[name].data;
    } catch(e) {
      throw e;
    }
  }

  Future<MarketStats> getMarketStats (int systemId, int typeId) async {
    try {
      var pair = Tuple2(systemId, typeId);
      if (shouldRetrieve(_systemMarketStats, pair, 15)) {
        var ci = CachedItem<MarketStats>();
        ci.data = EveMarketer.getMarketStats(typeId, systemId);
        ci.time = DateTime.now();
        _systemMarketStats[pair] = ci;
      }
      return await _systemMarketStats[pair].data;
    } catch(e) {
      throw e;
    }
  }

  Future<List<MarketHistory>> getMarketHistory (int regionId, int typeId) async {
    try {
      var pair = Tuple2(regionId, typeId);
      if (shouldRetrieve(_marketHistory, pair, 15)) {
        var ci = CachedItem<List<MarketHistory>>();
        ci.data = _marketApi.getMarketHistory(typeId, regionId);
        ci.time = DateTime.now();
        _marketHistory[pair] = ci;
      }
      return await _marketHistory[pair].data;
    } catch(e) {
      throw e;
    }
  }

  Future<List<MarketOrder>> getMarketOrders (int regionId) async {
    try {
      if (shouldRetrieve(_marketOrders, regionId, 15)) {
        var ci = CachedItem<List<MarketOrder>>();
        ci.data = _marketApi.getMarketOrders(regionId);
        ci.time = DateTime.now();
        _marketOrders[regionId] = ci;
      }
      return await _marketOrders[regionId].data;
    } catch(e) {
      throw e;
    }
  }

  Future<List<MarketOrder>> getMarketBuyOrders (int regionId) async {
    try {
      if (shouldRetrieve(_marketBuyOrders, regionId, 15)) {
        var ci = CachedItem<List<MarketOrder>>();
        ci.data = _marketApi.getMarketBuyOrders(regionId);
        ci.time = DateTime.now();
        _marketBuyOrders[regionId] = ci;
      }
      return await _marketBuyOrders[regionId].data;
    } catch(e) {
      throw e;
    }
  }

  Future<List<MarketOrder>> getMarketSellOrders (int regionId) async {
    try {
      if (shouldRetrieve(_marketSellOrders, regionId, 15)) {
        var ci = CachedItem<List<MarketOrder>>();
        ci.data = _marketApi.getMarketSellOrders(regionId);
        ci.time = DateTime.now();
        _marketSellOrders[regionId] = ci;
      }
      return await _marketSellOrders[regionId].data;
    } catch(e) {
      throw e;
    }
  }

  Future<List<MarketOrder>> getItemMarketOrders (int regionId, int typeId) async {
    try {
      var pair = Tuple2(regionId, typeId);
      if (shouldRetrieve(_itemMarketOrders, pair, 15)) {
        var ci = CachedItem<List<MarketOrder>>();
        ci.data = _marketApi.getItemMarketOrders(typeId, regionId);
        ci.time = DateTime.now();
        _itemMarketOrders[pair] = ci;
      }
      return await _itemMarketOrders[pair].data;
    } catch(e) {
      throw e;
    }
  }

  Future<List<MarketOrder>> getItemMarketBuyOrders (int regionId, int typeId) async {
    try {
      var pair = Tuple2(regionId, typeId);
      if (shouldRetrieve(_itemMarketBuyOrders, pair, 15)) {
        var ci = CachedItem<List<MarketOrder>>();
        ci.data = _marketApi.getItemMarketBuyOrders(typeId, regionId);
        ci.time = DateTime.now();
        _itemMarketBuyOrders[pair] = ci;
      }
      return await _itemMarketBuyOrders[pair].data;
    } catch(e) {
      throw e;
    }
  }

  Future<List<MarketOrder>> getItemMarketSellOrders (int regionId, int typeId) async {
    try {
      var pair = Tuple2(regionId, typeId);
      if (shouldRetrieve(_itemMarketSellOrders, pair, 15)) {
        var ci = CachedItem<List<MarketOrder>>();
        ci.data = _marketApi.getItemMarketSellOrders(typeId, regionId);
        ci.time = DateTime.now();
        _itemMarketSellOrders[pair] = ci;
      }
      return await _itemMarketSellOrders[pair].data;
    } catch(e) {
      throw e;
    }
  }

  Future<ConstellationInformation> getConstellationInformation (int id) async {
    try {
      if (shouldRetrieve(_constellationIdToInfo, id, 720)) {
        var ci = CachedItem<ConstellationInformation>();
        ci.data = _universeApi.getConstellationInformation(id);
        ci.time = DateTime.now();
        _constellationIdToInfo[id] = ci;
      }
      return await _constellationIdToInfo[id].data;
    } catch(e) {
      throw e;
    }
  }

  Future<SolarSystemInformation> getSolarSystemInformation (int id) async {
    try {
      if (shouldRetrieve(_systemIdToInfo, id, 720)) {
        var ci = CachedItem<SolarSystemInformation>();
        ci.data = _universeApi.getSolarSystemInformation(id);
        ci.time = DateTime.now();
        _systemIdToInfo[id] = ci;
      }
      return await _systemIdToInfo[id].data;
    } catch(e) {
      throw e;
    }
  }

  Future<StationInformation> getStationInformation (int id) async {
    try {
      if (shouldRetrieve(_stationIdToInfo, id, 720)) {
        var ci = CachedItem<StationInformation>();
        ci.data = _universeApi.getStationInformation(id);
        ci.time = DateTime.now();
        _stationIdToInfo[id] = ci;
      }
      return await _stationIdToInfo[id].data;
    } catch(e) {
      throw e;
    }
  }

  Future<StructureInformation> getStructureInformation (int id) async {
    try {
      if (shouldRetrieve(_structureIdToInfo, id, 720)) {
        var ci = CachedItem<StructureInformation>();
        ci.data = _universeApi.getStructureInformation(id);
        ci.time = DateTime.now();
        _structureIdToInfo[id] = ci;
      }
      return await _structureIdToInfo[id].data;
    } catch(e) {
      throw e;
    }
  }

  bool shouldRetrieve<T>(Map<T, CachedItem> map, T key, int timeout) {
    if (!map.containsKey(key) || map[key].age().inMinutes > timeout) return true;
    return false;
  }
}