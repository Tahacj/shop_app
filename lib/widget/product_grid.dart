import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import 'product_item.dart';

class ProdoctsGrid extends StatelessWidget {
  final bool showOnluFavorite;

  ProdoctsGrid(this.showOnluFavorite);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showOnluFavorite ? productsData.favoriteItem : productsData.items;
    return products.length == 0
        ? Center(
            child: Text(
              "There is no products!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
          )
        : GridView.builder(
            itemBuilder: (context, index) => ChangeNotifierProvider.value(
              // create: (context) => products[index], // use this with out value
              value: products[
                  index], // and this if u want to use value (pefer this)
              child: ProudctItem(),
            ),
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 3 / 2,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
  }
}
