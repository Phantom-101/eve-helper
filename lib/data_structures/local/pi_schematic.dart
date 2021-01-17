import 'package:eve_helper/data_structures/local/pi_schematic_material.dart';

class PISchematic {
  final int id;
  final String name;
  final List<PISchematicMaterial> outputs;
  final List<PISchematicMaterial> inputs;
  final int cycleTime;

  PISchematic({this.id, this.name, this.outputs, this.inputs, this.cycleTime});

  factory PISchematic.fromJson(Map<String, dynamic> json) {
    return PISchematic(
      id: json['id'],
      name: json['name'],
      outputs: json['outputs'].map<PISchematicMaterial>((element) => PISchematicMaterial.fromJson(element)).toList(),
      inputs: json['inputs'].map<PISchematicMaterial>((element) => PISchematicMaterial.fromJson(element)).toList(),
      cycleTime: json['cycleTime'],
    );
  }
}