import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
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

  var _showFavoriteOnly = false;

  final String authToken;
  final String userId;
  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    // if (_showFavoriteOnly) {
    //   return _items.where((prod) => prod.isFavorite).toList();
    // } else {
    return [..._items];
    //}
  }

  List<Product> get favoriteItem {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    // this works like get method
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://shop-app-fedfa-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final url2 = Uri.parse(
          "https://shop-app-fedfa-default-rtdb.firebaseio.com/userFavorite/$userId.json?auth=$authToken");
      final favoriteResponse = await http.get(url2);
      final favoriteItemsData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData["title"],
          description: prodData["description"],
          imageUrl: prodData["imageUrl"],
          price: prodData["price"],
          isFavorite: favoriteItemsData == null
              ? false
              : favoriteItemsData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> addProduct(Product product) async {
    // this works like post
    //dynamic newProduct;
    final url = Uri.parse(
        "https://shop-app-fedfa-default-rtdb.firebaseio.com/products.json?auth=$authToken");
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "creatorId": userId,
          },
        ),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        id: json.decode(response.body)["name"],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    // this works like put
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          "https://shop-app-fedfa-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken");
      http.patch(url,
          body: json.encode({
            "title": newProduct.title,
            "description": newProduct.description,
            "imageUrl": newProduct.imageUrl,
            "price": newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print(".........");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://shop-app-fedfa-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken");
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpExcaption("Could not delete product.");
    }
    existingProduct = null;
  }
}
