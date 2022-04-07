import 'package:flutter/material.dart';
import 'package:shop/helpers/custom_route.dart';
import 'package:shop/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/addProducts.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/orders.dart';
import 'package:shop/screens/products_overview.dart';
import 'package:shop/screens/user_products.dart';
import 'screens/product_details.dart';
import 'package:shop/providers/cart.dart';
import 'screens/cart_screen.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProvider(create: (_) => Cart()),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (_, auth, pp) =>
                pp == null ? (Products()..update(auth.token, auth.uid)) : pp
                  ..update(auth.token, auth.uid),
            create: (_) => Products(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (_, auth, pp) =>
                pp == null ? (Orders()..update(auth.token, auth.uid)) : pp
                  ..update(auth.token, auth.uid),
            create: (_) => Orders(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (_, auth, child) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder()
                }),
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
              ),
              home: auth.isAuth
                  ? ProductsOverview()
                  : FutureBuilder(
                      builder: (_, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : AuthScreen();
                      },
                      future: auth.tryAutoLogin(),
                    ),
              routes: {
                ProductDetail.routeName: (_) => ProductDetail(),
                CartScreen.routeName: (_) => CartScreen(),
                Allorders.routeName: (_) => Allorders(),
                UserProducts.routeName: (_) => UserProducts(),
                AddProduct.routeName: (_) => AddProduct()
              },
            );
          },
        ));
  }
}
