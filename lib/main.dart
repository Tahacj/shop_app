import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/admin_Screen.dart';
import 'package:flutter_complete_guide/screens/sozlesme_screen.dart';
import 'package:flutter_complete_guide/screens/user_info_screen.dart';
import 'package:provider/provider.dart';

import '../helpers/custom_route.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/add_product_screen.dart';
import './screens/edit_products_screen.dart';
import './screens/orders_Screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/cart.dart';
import './providers/products_provider.dart';
import './providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(), // it's batter to use the normal one here
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previousProducts) => Products(
              auth.token,
              previousProducts == null ? [] : previousProducts.items,
              auth.userId), // it's batter to use the normal one here
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previousOrders) => Orders(auth.token,
              previousOrders == null ? [] : previousOrders.orders, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.purple[900],
              fontFamily: "Lato",
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                },
              )),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultsnapshot) =>
                      authResultsnapshot.connectionState ==
                              ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: Theme.of(context).accentColor),
                            )
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            AddNewProductScreen.routeName: (context) => AddNewProductScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            AdminScreen.routeName: (context) => AdminScreen(),
            UserInfoScreen.routeName: (context) => UserInfoScreen(),
            SozlesmeScreen.routeName: (context) => SozlesmeScreen(),
            //AuthScreen.routeName: (context) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
