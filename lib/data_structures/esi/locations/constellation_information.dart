import 'package:tuple/tuple.dart';

class ConstellationInformation {
  final int constellationId;
  final String name;
  final Tuple3<double, double, double> position;
  final int regionId;
  final List<int> systems;

  ConstellationInformation({this.constellationId, this.name, this.position, this.regionId, this.systems});

  factory ConstellationInformation.fromJson(Map<String, dynamic> json) {
    return ConstellationInformation(
      constellationId: json['constellation_id'],
      name: json['name'],
      position: Tuple3(json['position']['x'], json['position']['y'], json['position']['z']),
      regionId: json['region_id'],
      systems: json['systems']?.cast<int>() ?? [],
    );
  }
}