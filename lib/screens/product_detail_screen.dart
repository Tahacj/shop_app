import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedProduct.title,
                textAlign: TextAlign.start,
              ),
              centerTitle: false,
              background: Card(
                  elevation: 8,
                  child: Hero(
                      tag: loadedProduct.id,
                      child: Image.network(
                        loadedProduct.imageUrl,
                        fit: BoxFit.cover,
                      ))),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Card(
              margin: EdgeInsets.all(10),
              child: Column(children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "\$ ${loadedProduct.price}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(loadedProduct.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    loadedProduct.description,
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 1000,
                ),
              ]),
            )
          ])),
        ],
      ),
    );
  }
}
