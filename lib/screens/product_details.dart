import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    Product product =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
        // appBar: AppBar(
        //   title: Text(product.title),
        // ),
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 300,
          // title: Text(product.title),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(product.title),
            background: Hero(
              tag: product.id,
              child: Image.network(
                product.imageUrl,
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
            height: 10,
          ),
          Text(
            '\$${product.price}',
            style: TextStyle(color: Colors.grey, fontSize: 26),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              product.description,
              softWrap: true,
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(
            height: 800,
          )
        ]))
      ],
    ));
  }
}
