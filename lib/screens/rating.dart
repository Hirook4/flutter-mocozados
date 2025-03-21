import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mocozados/models/local_model.dart';
import 'package:mocozados/models/rating_model.dart';

class Rating extends StatelessWidget {
  Rating({super.key});

  final LocalModel localModel = LocalModel(
    id: "001",
    name: "Matinho",
    latitude: -21.177766,
    longitude: -48.144947,
    link: "https://maps.app.goo.gl/VLE4mC2MbcvRwgUT8",
  );

  final List<RatingModel> ratingList = [
    RatingModel(
      id: "001",
      name: "Bom lugar, porem ouvi falar que vao instalar cameras por la",
      date: DateTime(2025, 2, 25),
      rating: 7.5,
    ),
    RatingModel(
      id: "002",
      name: "Achei OK",
      date: DateTime(2025, 3, 5),
      rating: 10,
    ),
    RatingModel(
      id: "003",
      name: "Achei ruim, pisei na terra e rasguei a calça",
      date: DateTime(2025, 3, 10),
      rating: 5.5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB5A8D5),
      appBar: AppBar(
        title: Text(
          "Local: ${localModel.name} - Nota: ${ratingList[0].rating.toStringAsFixed(1)}",
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView(
            children:
                ratingList.map((rating) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          rating.name,
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy').format(rating.date),
                        ),
                      ),
                      Divider(color: Colors.black),
                    ],
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
