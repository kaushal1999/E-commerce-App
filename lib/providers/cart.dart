import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  CartItem(
      {required this.id,
      required this.price,
      required this.quantity,
      required this.title});
}

class Cart with ChangeNotifier {
  // late String _authToken;
  Map<String, CartItem> _items = {};

  // void update(String token) {
  //   _authToken = token;
  // }

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get cartCount {
    return _items.length;
  }

  double get total {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((key, value) => key == id);
    notifyListeners();
  }

  void addItem(String title, String id, double price) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (value) => CartItem(
              id: value.id,
              price: value.price,
              quantity: value.quantity + 1,
              title: value.title));
    } else {
      _items.putIfAbsent(
          id,
          () => CartItem(
              id: DateTime.now().toString(),
              price: price,
              quantity: 1,
              title: title));
    }
    notifyListeners();
  }

  void removeFromCart(String id) {
    if (_items[id]!.quantity > 1) {
      _items.update(
          id,
          (value) => CartItem(
              id: value.id,
              price: value.price,
              quantity: value.quantity - 1,
              title: value.title));
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }
}
