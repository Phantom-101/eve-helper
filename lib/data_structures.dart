class SolarSystemInformation {
  final int constellationId;
  final String name;
  final String securityClass;
  final double securityStatus;
  final int starId;
  final List<int> stargates;
  final List<int> stations;
  final int systemId;

  SolarSystemInformation({this.constellationId, this.name, this.securityClass, this.securityStatus, this.starId, this.stargates, this.stations, this.systemId});

  factory SolarSystemInformation.fromJson(Map<String, dynamic> json) {
    return SolarSystemInformation(
      constellationId: json['constellation_id'],
      name: json['name'],
      securityClass: json['security_class'],
      securityStatus: json['security_status'],
      starId: json['star_id'],
      stargates: json['stargates']?.cast<int>() ?? [],
      stations: json['stations']?.cast<int>() ?? [],
      systemId: json['system_id'],
    );
  }
}

class InvadedSolarSystemInformation {
  final int systemId;
  final String status;
  final String derivedSecurityStatus;
  final String updatedAt;
  final String systemName;
  final String systemSecurity;
  final String systemSovereignty;

  InvadedSolarSystemInformation({this.systemId, this.status, this.derivedSecurityStatus, this.updatedAt, this.systemName, this.systemSecurity, this.systemSovereignty});

  factory InvadedSolarSystemInformation.fromJson(Map<String, dynamic> json) {
    return InvadedSolarSystemInformation(
      systemId: json['system_id'],
      status: json['status'],
      derivedSecurityStatus: json['derived_security_status'],
      updatedAt: json['updated_at'],
      systemName: json['system_name'],
      systemSecurity: json['system_security'],
      systemSovereignty: json['system_sovereignty'],
    );
  }
}

class AlphaTrainableSkillList {
  final RacialTrainableSkillList gallente;
  final RacialTrainableSkillList caldari;
  final RacialTrainableSkillList minmatar;
  final RacialTrainableSkillList amarr;

  AlphaTrainableSkillList({this.gallente, this.caldari, this.minmatar, this.amarr});

  factory AlphaTrainableSkillList.fromJson(Map<String, dynamic> json) {
    return AlphaTrainableSkillList(
      gallente: RacialTrainableSkillList.fromJson(json['8']),
      caldari: RacialTrainableSkillList.fromJson(json['1']),
      minmatar: RacialTrainableSkillList.fromJson(json['2']),
      amarr: RacialTrainableSkillList.fromJson(json['4']),
    );
  }
}

class RacialTrainableSkillList {
  final Map<int, int> trainableLevel;
  final String internalDescription;

  RacialTrainableSkillList({this.trainableLevel, this.internalDescription});

  factory RacialTrainableSkillList.fromJson(Map<String, dynamic> json) {
    return RacialTrainableSkillList(
      trainableLevel: json['skills'],
      internalDescription: json['internalDescription'],
    );
  }
}

class BlueprintInformation {
  final int requestId;
  final BlueprintSkills skills;
  final BlueprintDetails details;
  final BlueprintActivityMaterials activityMaterials;

  BlueprintInformation({this.requestId, this.skills, this.details, this.activityMaterials});

  factory BlueprintInformation.fromJson(Map<String, dynamic> json) {
    return BlueprintInformation(
      requestId: json['requestid'],
      skills: BlueprintSkills.fromJson(json['blueprintSkills']),
      details: BlueprintDetails.fromJson(json['blueprintDetails']),
      activityMaterials: BlueprintActivityMaterials.fromJson(json['activityMaterials']),
    );
  }
}

class BlueprintSkills {
  final List<BlueprintSkillInformation> manufacture;
  final List<BlueprintSkillInformation> invention;

  BlueprintSkills({this.manufacture, this.invention});

  factory BlueprintSkills.fromJson(Map<String, dynamic> json) {
    return BlueprintSkills(
      manufacture: json['1']?.map<BlueprintSkillInformation>((obj) => BlueprintSkillInformation.fromJson(obj))?.toList(),
      invention: json['8']?.map<BlueprintSkillInformation>((obj) => BlueprintSkillInformation.fromJson(obj))?.toList(),
    );
  }
}

class BlueprintSkillInformation {
  final int typeId;
  final String name;
  final int level;

  BlueprintSkillInformation({this.typeId, this.name, this.level});

  factory BlueprintSkillInformation.fromJson(Map<String, dynamic> json) {
    return BlueprintSkillInformation(
      typeId: json['typeid'],
      name: json['name'],
      level: json['level'],
    );
  }
}

class BlueprintDetails {
  final int maxProductionLimit;
  final int productTypeId;
  final String productTypeName;
  final int productQuantity;
  final Map<String, int> times;
  final List<String> facilities;
  final int techLevel;
  final double adjustedPrice;

  BlueprintDetails({this.maxProductionLimit, this.productTypeId, this.productTypeName, this.productQuantity, this.times, this.facilities, this.techLevel, this.adjustedPrice});

  factory BlueprintDetails.fromJson(Map<String, dynamic> json) {
    return BlueprintDetails(
      maxProductionLimit: json['maxProductionLimit'],
      productTypeId: json['productTypeID'],
      productTypeName: json['productTypeName'],
      productQuantity: json['productQuantity'],
      times: Map<String, int>.from(json['times']),
      facilities: json['facilities'].cast<String>(),
      techLevel: json['techLevel'],
      adjustedPrice: json['adjustedPrice'].toDouble(),
    );
  }
}

class BlueprintActivityMaterials {
  final List<BlueprintActivityMaterialInformation> manufacture;
  final List<BlueprintActivityMaterialInformation> invention;

  BlueprintActivityMaterials({this.manufacture, this.invention});

  factory BlueprintActivityMaterials.fromJson(Map<String, dynamic> json) {
    return BlueprintActivityMaterials(
      manufacture: json['1']?.map<BlueprintActivityMaterialInformation>((obj) => BlueprintActivityMaterialInformation.fromJson(obj))?.toList(),
      invention: json['8']?.map<BlueprintActivityMaterialInformation>((obj) => BlueprintActivityMaterialInformation.fromJson(obj))?.toList(),
    );
  }
}

class BlueprintActivityMaterialInformation {
  final int typeId;
  final String name;
  final int quantity;
  final int makeType;

  BlueprintActivityMaterialInformation({this.typeId, this.name, this.quantity, this.makeType});

  factory BlueprintActivityMaterialInformation.fromJson(Map<String, dynamic> json) {
    return BlueprintActivityMaterialInformation(
      typeId: json['typeid'],
      name: json['name'],
      quantity: json['quantity'],
      makeType: json['maketype'],
    );
  }
}

class WormholeInformation {
  final String identifier;
  final String destination;
  final String appearsIn;
  final int lifetime;
  final int maxMassPerJump;
  final int totalJumpMass;
  final int massRegen;
  final String respawn;

  WormholeInformation({this.identifier, this.destination, this.appearsIn, this.lifetime = 16, this.maxMassPerJump = 20, this.totalJumpMass = 500, this.massRegen = 0, this.respawn = 'Wandering'});
}