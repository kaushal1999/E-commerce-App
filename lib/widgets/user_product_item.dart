import 'package:flutter/material.dart';
import 'package:shop/screens/addProducts.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String imageUrl;
  final String id;
  final String title;

  UserProductItem(this.imageUrl, this.title, this.id);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AddProduct.routeName, arguments: id);
                },
                icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .delete(id);
                  } catch (e) {
                    // print(e.toString());
                    scaffold.showSnackBar(
                        SnackBar(content: Text('deleting failed')));
                  }
                },
                icon: Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
