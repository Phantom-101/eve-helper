class SolarSystemCostIndices {
  final double manufacturing;
  final double teResearch;
  final double meResearch;
  final double copying;
  final double invention;
  final double reaction;
  final int solarSystemId;

  SolarSystemCostIndices({this.manufacturing, this.teResearch, this.meResearch, this.copying, this.invention, this.reaction, this.solarSystemId});

  factory SolarSystemCostIndices.fromJson(Map<String, dynamic> json) {
    return SolarSystemCostIndices(
      manufacturing: json['cost_indices'][0]['cost_index'],
      teResearch: json['cost_indices'][1]['cost_index'],
      meResearch: json['cost_indices'][2]['cost_index'],
      copying: json['cost_indices'][3]['cost_index'],
      invention: json['cost_indices'][4]['cost_index'],
      reaction: json['cost_indices'][5]['cost_index'],
      solarSystemId: json['solar_system_id'],
    );
  }
}