import 'package:tuple/tuple.dart';

class StationInformation {
  final double maxDockableShipVolume;
  final String name;
  final double officeRentalCost;
  final int owner;
  final Tuple3<double, double, double> position;
  final int raceId;
  final double reprocessingEfficiency;
  final double reprocessingStationsTake;
  final List<String> services;
  final int stationId;
  final int systemId;
  final int typeId;

  StationInformation({this.maxDockableShipVolume, this.name, this.officeRentalCost, this.owner, this.position, this.raceId, this.reprocessingEfficiency, this.reprocessingStationsTake, this.services, this.stationId, this.systemId, this.typeId});

  factory StationInformation.fromJson(Map<String, dynamic> json) {
    return StationInformation(
      maxDockableShipVolume: json['max_dockable_ship_volume'],
      name: json['name'],
      officeRentalCost: json['office_rental_cost'],
      owner: json['owner'],
      position: Tuple3(json['position']['x'], json['position']['y'], json['position']['z']),
      raceId: json['race_id'],
      reprocessingEfficiency: json['reprocessing_efficiency'],
      reprocessingStationsTake: json['reprocessing_stations_take'],
      services: json['services'].cast<String>(),
      stationId: json['station_id'],
      systemId: json['system_id'],
      typeId: json['type_id'],
    );
  }
}