import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/widgets/ItemCart.dart';
import 'package:shop/providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.total.toStringAsFixed(2)}'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) {
                return ItemCart(
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity,
                    cart.items.values.toList()[i].title,
                    cart.items.keys.toList()[i]);
              },
              itemCount: cart.cartCount,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        color: Theme.of(context).primaryColor,
        disabledColor: Colors.grey,
        onPressed: widget.cart.total == 0 || _isLoading
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.total, widget.cart.items.values.toList());
                widget.cart.clear();

                setState(() {
                  _isLoading = false;
                });
              },
        child: _isLoading
            ? CircularProgressIndicator(
                // strokeWidth: 2,
                // backgroundColor: Colors.white,

                )
            : Text(
                'ORDER NOW',
                style: TextStyle(color: Colors.white),
              ));
  }
}
