class LocalModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String link;

  /* Construtor principal da classe LocalModel. */
  const LocalModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.link,
  });

  /* Construtor nomeado para criar um objeto LocalModel a partir de um Map. */
  factory LocalModel.fromMap(Map<String, dynamic> map) {
    return LocalModel(
      id: map["id"] as String? ?? "",
      name: map["name"] as String? ?? "Local sem nome",
      latitude: (map["latitude"] is num)
          ? (map["latitude"] as num).toDouble()
          : 0.0,
      longitude: (map["longitude"] is num)
          ? (map["longitude"] as num).toDouble()
          : 0.0,
      link: map["link"] as String? ?? "",
    );
  }

  /* Converte um objeto LocalModel em um Map<String, dynamic>. */
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "latitude": latitude,
      "longitude": longitude,
      "link": link,
    };
  }
}
