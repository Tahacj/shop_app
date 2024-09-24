import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoritStatus(String authToken, String userId) async {
    final url = Uri.parse(
        "https://shop-app-fedfa-default-rtdb.firebaseio.com/userFavorite/$userId/$id.json?auth=$authToken");
    final oldState = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      if (response.statusCode >= 400) {
        isFavorite = oldState;
        notifyListeners();
      }
    } catch (err) {
      isFavorite = oldState;
      notifyListeners();
    }
  }
}
