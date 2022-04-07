import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/drawer.dart';
import 'package:shop/widgets/order_item.dart';

class Allorders extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _AllordersState createState() => _AllordersState();
}

class _AllordersState extends State<Allorders> {
  Future? ordersFuture;
  Future getOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    super.initState();
    ordersFuture = getOrdersFuture();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Consumer<Orders>(
                builder: (_, orderData, child) {
                  return ListView.builder(
                    itemBuilder: (ctx, i) {
                      return ItemOrder(orderData.orders[i]);
                    },
                    itemCount: orderData.orders.length,
                  );
                },
              );
            }
          },
        ));
  }
}
