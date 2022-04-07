import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/screens/addProducts.dart';
import 'package:shop/widgets/drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProducts extends StatelessWidget {
  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  static const routeName = '/userProducts';
  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AddProduct.routeName, arguments: null);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (_, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refresh(context),
                    child: Consumer<Products>(
                      builder: (_, products, ch) => ListView.builder(
                        itemBuilder: (_, i) {
                          return Column(
                            children: [
                              UserProductItem(
                                  products.products[i].imageUrl,
                                  products.products[i].title,
                                  products.products[i].id),
                              Divider()
                            ],
                          );
                        },
                        itemCount: products.products.length,
                      ),
                    ),
                  ),
      ),
    );
  }
}
