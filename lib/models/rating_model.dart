class RatingModel {
  final String id;
  final String name;
  final DateTime date;
  final double rating;

  RatingModel({
    required this.id,
    required this.name,
    required this.date,
    required this.rating,
  });

  /* Construtor nomeado para converter um Map em um objeto RatingModel */
  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      id: map["id"] as String? ?? "",
      name: map["name"] as String? ?? "Sem nome",
      date: DateTime.tryParse(map["date"] as String? ?? "") ?? DateTime.now(),
      rating:
          (map["rating"] is double)
              ? map["rating"] as double
              : (map["rating"] as double?)?.toDouble() ?? 0,
    );
  }

  /* Método para converter um objeto RatingModel em um Map<String, dynamic> */
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "date": date.toIso8601String(),
      "rating": rating,
    };
  }
}
