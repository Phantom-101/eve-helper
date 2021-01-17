import 'dart:convert';
import 'package:eve_helper/data_structures.dart';
import 'package:eve_helper/data_structures/local/pi_schematic.dart';
import 'package:flutter/services.dart';

class Local {
  static Future<List<WormholeInformation>> getWormholes() async {
    List<WormholeInformation> wormholes = [];
    String jsonStr = await rootBundle.loadString('assets/databases/wormholes.json');
    Map<String, dynamic> json = jsonDecode(jsonStr);
    for (Map<String, dynamic> wormholeJson in json['wormholes'])
      wormholes.add(WormholeInformation(
        identifier: wormholeJson['name'],
        destination: wormholeJson['to'],
        appearsIn: wormholeJson['from'],
        lifetime: wormholeJson['lifetime'],
        maxMassPerJump: wormholeJson['maxJumpMass'],
        totalJumpMass: wormholeJson['totalStableMass'],
        massRegen: wormholeJson['massRegeneration'],
      ));
    return wormholes;
  }

  static Future<List<PISchematic>> getPISchematics() async {
    List<PISchematic> schematics = [];
    String jsonStr = await rootBundle.loadString('assets/databases/pi_schematics.json');
    Map<String, dynamic> json = jsonDecode(jsonStr);
    for (Map<String, dynamic> schematicJson in json['schematics'])
      schematics.add(PISchematic.fromJson(schematicJson));
    return schematics;
  }
}