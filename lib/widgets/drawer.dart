import 'package:flutter/material.dart';
import 'package:shop/screens/orders.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/helpers/custom_route.dart';
import 'package:shop/screens/user_products.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend!'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Your orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Allorders.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage your products'),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(UserProducts.routeName);
              Navigator.pushReplacement(
                  context, CustomRoute(builder: (_) => UserProducts()));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              // Navigator.of(context).pop();

              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/');
              // print('bhh');
            },
          ),
        ],
      ),
    );
  }
}
