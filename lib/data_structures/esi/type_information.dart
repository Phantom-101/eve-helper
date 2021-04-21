class TypeInformation {
  final double capacity;
  final String description;
  // todo add dogma attributes and dogma effects
  final int graphicId;
  final int groupId;
  final int iconId;
  final int marketGroupId;
  final double mass;
  final String name;
  final double packagedVolume;
  final int portionSize;
  final bool published;
  final double radius;
  final int typeId;
  final double volume;

  TypeInformation({this.capacity, this.description, this.graphicId, this.groupId, this.iconId, this.marketGroupId, this.mass, this.name, this.packagedVolume, this.portionSize, this.published, this.radius, this.typeId, this.volume});

  factory TypeInformation.fromJson(Map<String, dynamic> json) {
    return TypeInformation(
      capacity: json['capacity'] ?? 0,
      description: json['description'],
      graphicId: json['graphic_id'] ?? 0,
      groupId: json['group_id'],
      iconId: json['icon_id'] ?? 0,
      marketGroupId: json['market_group_id'] ?? 0,
      mass: json['mass'] ?? 0,
      name: json['name'],
      packagedVolume: json['packaged_volume'] ?? 0,
      portionSize: json['portion_size'] ?? 1,
      published: json['published'],
      radius: json['radius'] ?? 0,
      typeId: json['typeId'],
      volume: json['volume'] ?? 0,
    );
  }
}