import 'package:tuple/tuple.dart';

class StructureInformation {
  final String name;
  final int ownerId;
  final Tuple3<double, double, double> position;
  final int systemId;
  final int typeId;

  StructureInformation({this.name, this.ownerId, this.position, this.systemId, this.typeId});

  factory StructureInformation.fromJson(Map<String, dynamic> json) {
    return StructureInformation(
      name: json['name'],
      ownerId: json['owner_id'],
      position: Tuple3(json['position']['x'], json['position']['y'], json['position']['z']),
      systemId: json['system_id'],
      typeId: json['type_id'],
    );
  }
}