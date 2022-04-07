import 'package:flutter/foundation.dart';
import 'package:shop/providers/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/widgets/httpException.dart';

class Products with ChangeNotifier {
  String? _authToken;
  String? _uid;
  // Products(this.authToken,this._products);
  List<Product> _products = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  void update(String? token, String? uid) {
    _authToken = token;
    _uid = uid;
  }

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favProducts {
    return _products.where((element) => element.isFav).toList();
  }

  Product findById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-3502e-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$_authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'description': product.description,
            'title': product.title,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': _uid
          }));

      var newProduct = Product(
          title: product.title,
          description: product.description,
          id: json.decode(response.body)['name'],
          imageUrl: product.imageUrl,
          price: product.price);
      _products.add(newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final index = _products.indexWhere((element) => element.id == id);
    final url = Uri.parse(
        'https://flutter-3502e-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$_authToken');
    await http.patch(url,
        body: json.encode({
          'description': product.description,
          'title': product.title,
          'price': product.price,
          'imageUrl': product.imageUrl
        }));
    _products[index] = product;
    notifyListeners();
  }

  Future<void> delete(String id) async {
    final url = Uri.parse(
        'https://flutter-3502e-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$_authToken');
    final existingProductIndex =
        _products.indexWhere((element) => element.id == id);
    var existingProduct = _products[existingProductIndex];
    _products.removeWhere((element) => element.id == id);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _products.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('deleting failed');
    }
  }

  Future<void> fetchProducts([var filterById = false]) async {
    // String filterString =
    //     filterById ? '&orderBy="creatorId"&equalTo="$_uid"' : '';
    var url = Uri.parse(
        'https://flutter-3502e-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$_authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://flutter-3502e-default-rtdb.asia-southeast1.firebasedatabase.app/userFav/$_uid.json?auth=$_authToken');
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);

      List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        Map m = extractedData[key];
        loadedProducts.add(Product(
            description: m['description'],
            id: key,
            isFav: favData == null ? false : favData[key] ?? false,
            imageUrl: m['imageUrl'],
            price: m['price'],
            title: m['title']));
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
