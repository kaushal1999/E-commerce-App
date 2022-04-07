import 'package:flutter/material.dart';
import 'package:shop/providers/orders.dart';
import 'package:intl/intl.dart';

class ItemOrder extends StatefulWidget {
  final OrderItem order;
  ItemOrder(this.order);

  @override
  _ItemOrderState createState() => _ItemOrderState();
}

class _ItemOrderState extends State<ItemOrder> {
  var _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
          subtitle:
              Text(DateFormat('dd-MM-yyyy hh:mm').format(widget.order.date)),
          trailing: IconButton(
            icon:
                _isExpanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
        ),
        AnimatedContainer(
          curve: Curves.linear,
          duration: Duration(milliseconds: 500),
          constraints: BoxConstraints(
              maxHeight: _isExpanded ? 200 : 0, minHeight: _isExpanded ? 1 : 0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(children: [
              ...widget.order.products.map((e) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.title),
                    Text('${e.quantity}x  \$${e.quantity * e.price}')
                  ],
                );
              }).toList(),
            ]),
          ),
        ),
      ],
    );
  }
}
