import 'package:eve_helper/eve_helper.dart';
import 'package:eve_helper/helpers/esi/industry_api.dart';
import 'package:eve_helper/helpers/esi/market_api.dart';
import 'package:eve_helper/helpers/esi/routes_api.dart';
import 'package:eve_helper/helpers/esi/search_api.dart';
import 'package:eve_helper/helpers/esi/universe_api.dart';
import 'package:eve_helper/helpers/local/cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

void main() {
  Client client = Client();
  IndustryApi industryApi = IndustryApi(client);
  MarketApi marketApi = MarketApi(client);
  RoutesApi routesApi = RoutesApi(client);
  SearchApi searchApi = SearchApi(client);
  UniverseApi universeApi = UniverseApi(client);
  Cache cache = Cache(industryApi, marketApi, routesApi, searchApi, universeApi);
  runApp(
    Material(
      child: MultiProvider(
        providers: [
          Provider<Cache>.value(value: cache),
          Provider<IndustryApi>.value(value: industryApi),
          Provider<MarketApi>.value(value: marketApi),
          Provider<RoutesApi>.value(value: routesApi),
          Provider<SearchApi>.value(value: searchApi),
          Provider<UniverseApi>.value(value: universeApi),
        ],
        child: EVEHelper(),
      ),
    )
  );
}