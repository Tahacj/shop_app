import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String authToken;
  final String userId;
  Orders(this.authToken, this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final date = DateTime.now();
    final url = Uri.parse(
        "https://shop-app-fedfa-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken");
    final response = await http.post(
      url,
      body: json.encode(
        {
          "amount": total,
          "dateTime": date.toIso8601String(),
          "products": cartProducts
              .map(
                (e) => {
                  "id": e.id,
                  "title": e.title,
                  "quantity": e.quantity,
                  "price": e.price,
                },
              )
              .toList(),
        },
      ),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)["name"],
        amount: total,
        dateTime: date,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<Void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-app-fedfa-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final List<OrderItem> loadedOrders = [];
    final response = await http.get(url);
    final extraxtedData = json.decode(response.body) as Map<String, dynamic>;
    if (extraxtedData == null) {
      return null;
    }
    extraxtedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData["amount"],
        products: (orderData["products"] as List<dynamic>)
            .map((e) => CartItem(
                  id: e["id"],
                  title: e["title"],
                  quantity: e["quantity"],
                  price: e["price"],
                ))
            .toList(),
        dateTime: DateTime.parse(orderData["dateTime"]),
      ));
    });
    _orders = loadedOrders;
    notifyListeners();
  }
}
