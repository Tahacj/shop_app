import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widget/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    //final orderDate = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text("orders")),
      drawer: AppDrware(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              //..
              return Center(
                child: Text("An Error occurred!"),
              );
            } else {
              return Consumer<Orders>(
                builder: (context, orderDate, child) => ListView.builder(
                  itemBuilder: (context, index) =>
                      OrderItem(orderDate.orders[index]),
                  itemCount: orderDate.orders.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
