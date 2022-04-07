import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

class ItemCart extends StatelessWidget {
  final double price;
  final String title;
  final String productId;
  final int quantity;
  ItemCart(this.price, this.quantity, this.title, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (c) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to remove?'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('No')),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('YES'))
                ],
              );
            });
      },
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).remove(productId);
      },
      key: ValueKey(productId),
      background: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.delete,
            size: 30,
            color: Colors.white,
          ),
        ),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
      ),
      direction: DismissDirection.endToStart,
      child: ListTile(
        leading: CircleAvatar(
          child: FittedBox(child: Text('\$$price')),
        ),
        title: Text(title),
        subtitle: Text('\$${quantity * price}'),
        trailing: Text('$quantity x'),
      ),
    );
  }
}
