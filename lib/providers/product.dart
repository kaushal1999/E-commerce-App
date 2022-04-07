import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop/widgets/httpException.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  bool isFav;
  final String imageUrl;

  Product(
      {required this.description,
      required this.id,
      required this.imageUrl,
      this.isFav = false,
      required this.price,
      required this.title});

  Future<void> toggleFav(String token, String uid) async {
    final url = Uri.parse(
        'https://flutter-3502e-default-rtdb.asia-southeast1.firebasedatabase.app/userFav/$uid/$id.json?auth=$token');

    isFav = !isFav;
    notifyListeners();

    final response = await http.put(url, body: json.encode(isFav));
    if (response.statusCode >= 400) {
      isFav = !isFav;
      notifyListeners();
      throw HttpException('toggle fav failed');
    }
  }
}
