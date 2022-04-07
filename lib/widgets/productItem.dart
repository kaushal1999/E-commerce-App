import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/product_details.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);

    final scaffold = Scaffold.of(context);
    final product = Provider.of<Product>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(ProductDetail.routeName, arguments: product.id);
              },
              child: Hero(
                tag: product.id,
                child: FadeInImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(product.imageUrl),
                    placeholder: AssetImage(
                      'assets/images/product-placeholder.png',
                    )),
              )),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            leading: Consumer<Product>(
              builder: (ctx, item, _) => IconButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () async {
                    try {
                      await item.toggleFav(authData.token, authData.uid);
                    } catch (_) {
                      scaffold.showSnackBar(
                          SnackBar(content: Text('toggle failed')));
                    }
                  },
                  icon: item.isFav
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border)),
            ),
            trailing: Consumer<Cart>(
                builder: (ctx, cart, ch) => IconButton(
                      color: Theme.of(context).accentColor,
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        cart.addItem(product.title, product.id, product.price);
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Added item to cart'),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              Provider.of<Cart>(context, listen: false)
                                  .removeFromCart(product.id);
                            },
                          ),
                        ));
                      },
                    )),
          )),
    );
  }
}
