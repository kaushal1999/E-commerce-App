import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/widgets/drawer.dart';
import 'package:shop/widgets/product_grid.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products.dart';

enum filters { onlyFav, all }

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showFav = false;
  var isInit = false;

  @override
  void didChangeDependencies() {
    if (isInit == false) {
      super.didChangeDependencies();

      Provider.of<Products>(context, listen: false)
          .fetchProducts()
          .catchError((_) async {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('An error occured!'),
                content: Text('something went wrong!'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Okay'))
                ],
              );
            });
      });

      isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Myshop'),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('Only favorites'),
                  value: filters.onlyFav,
                ),
                PopupMenuItem(
                  child: Text('All'),
                  value: filters.all,
                ),
              ],
              onSelected: (filters value) {
                setState(() {
                  if (value == filters.onlyFav) {
                    _showFav = true;
                  } else {
                    _showFav = false;
                  }
                });
              },
              child: Icon(Icons.more_vert),
            ),
            Consumer<Cart>(
              builder: (ctx, cart, ch) =>
                  Badge(value: cart.cartCount.toString(), child: ch!),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  size: 35,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                },
              ),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: ProductGrid(_showFav));
  }
}
