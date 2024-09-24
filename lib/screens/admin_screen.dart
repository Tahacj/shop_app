import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widget/user_item.dart';
import 'package:provider/provider.dart';

import '../screens/edit_products_screen.dart';
import '../providers/products_provider.dart';
import '../widget/app_drawer.dart';

class AdminScreen extends StatelessWidget {
  static const routeName = "/admin_page";

  Future<Void> _refreshUsers(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    //final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Users"),
      ),
      drawer: AppDrware(),
      body: FutureBuilder(
        future: _refreshUsers(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: (() => _refreshUsers(context)),
                    child: Consumer<Products>(
                      builder: (context, products, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (context, index) => Column(
                            children: [
                              UserItem(
                                products.items[index].id,
                                products.items[index].title,
                                products.items[index].imageUrl,
                              ),
                              Divider(color: Colors.black),
                            ],
                          ),
                          itemCount: products.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
