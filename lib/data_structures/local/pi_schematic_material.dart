class PISchematicMaterial {
  final int id;
  final int quantity;

  PISchematicMaterial({this.id, this.quantity});

  factory PISchematicMaterial.fromJson(Map<String, dynamic> json) {
    return PISchematicMaterial(
      id: json['id'],
      quantity: json['quantity'],
    );
  }
}