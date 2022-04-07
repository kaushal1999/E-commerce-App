import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  String id;
  double amount;
  List<CartItem> products;
  DateTime date;
  OrderItem(
      {required this.amount,
      required this.id,
      required this.products,
      required this.date});
}

class Orders with ChangeNotifier {
  String? _authToken;
  String? _uid;
  List<OrderItem> _orders = [];

  void update(String? token, String? uid) {
    _authToken = token;
    _uid = uid;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(double amount, List<CartItem> cart) async {
    final timestamp = DateTime.now();
    var url = Uri.parse(
        'https://flutter-3502e-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$_uid.json?auth=$_authToken');

    final response = await http.post(url,
        body: json.encode({
          'amount': amount,
          'date': timestamp.toIso8601String(),
          'products': cart.map((e) {
            return {
              'id': e.id,
              'price': e.price,
              'quantity': e.quantity,
              'title': e.title
            };
          }).toList()
        }));

    _orders.insert(
        0,
        OrderItem(
            amount: amount,
            date: timestamp,
            id: json.decode(response.body)['name'],
            products: cart));
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://flutter-3502e-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$_uid.json?auth=$_authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }

      List<OrderItem> loadedOrders = [];
      extractedData.forEach((key, value) {
        loadedOrders.add(OrderItem(
            amount: value['amount'],
            id: key,
            products: (value['products'] as List<dynamic>).map((e) {
              return CartItem(
                  id: e['id'],
                  price: e['price'],
                  quantity: e['quantity'],
                  title: e['title']);
            }).toList(),
            date: DateTime.parse(value['date'])));
      });
      // print(loadedOrders.length);
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (_) {}
  }
}
