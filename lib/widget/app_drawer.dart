import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/custom_route.dart';
import 'package:flutter_complete_guide/screens/admin_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/add_product_screen.dart';
import '../screens/orders_Screen.dart';

class AppDrware extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          backgroundColor: Colors.amber,
          title: Text(
            "De Khellos!! ",
            style: TextStyle(
                color: Colors.purple,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shopping_bag),
          title: Text("Shop"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed("/");
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text("Orders"),
          onTap: () {
            // Navigator.of(context).pushReplacement(
            //   CustomRoute(
            //     builder: (context) => OrdersScreen(),
            //   ),
            // );
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("Admin"),
          onTap: () {
            Navigator.of(context).pushNamed(AdminScreen.routeName);
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
        // Divider(),
        // ListTile(
        //   leading: Icon(Icons.edit),
        //   title: Text("Products"),
        //   onTap: () {
        //     Navigator.of(context)
        //         .pushReplacementNamed(AddNewProductScreen.routeName);
        //   },
        // ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text("Logout"),
          onTap: () {
            Navigator.of(context).pushNamed("/");
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ]),
    );
  }
}
