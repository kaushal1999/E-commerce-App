import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/widgets/httpException.dart';

enum AuthMode { login, signup }

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
              Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                child: Card(
                  // margin: EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.deepOrange,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 74),
                    child: Text(
                      'MyShop',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: AuthCard(),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  AuthMode _authMode = AuthMode.login;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final passwordController = TextEditingController();
  var _isLoading = false;

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    // _heightAnimation = Tween(
    //         begin: Size(double.infinity, 300), end: Size(double.infinity, 350))
    //     .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    // _heightAnimation.addListener(() {
    //   setState(() {});
    // });
  }

  void _showDialog(String errMsg) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('An error occured!'),
            content: Text(errMsg),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okay'))
            ],
          );
        });
  }

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Future<void> _switchAuthMode() async {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _controller.forward();
    } else {
      _controller.reverse();

      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.signup) {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email']!, _authData['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      }
    } on HttpException catch (error) {
      var errorMsg = 'Authentiaction failed! Try again';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMsg = 'email already in use';
        _showDialog(errorMsg);
      }
    } catch (_) {
      const errorMsg = 'Authentiaction failed! Try again';
      _showDialog(errorMsg);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.linear,
            alignment: Alignment.center,
            margin: EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.all(25),
            height: _authMode == AuthMode.login ? 350 : 450,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    onSaved: (newvalue) => _authData['email'] = newvalue!,
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'innvalid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'E-mail'),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'invalid password';
                      }
                      return null;
                    },
                    controller: passwordController,
                    onSaved: (newvalue) => _authData['password'] = newvalue!,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  // AnimatedContainer(
                  //   curve: Curves.linear,
                  //   constraints: BoxConstraints(
                  //       minHeight: _authMode == AuthMode.login ? 0.0 : 0.0,
                  //       maxHeight: _authMode == AuthMode.login ? 0.0 : 120.0),
                  //   duration: Duration(milliseconds: 2000),
                  // height: _authMode == AuthMode.login ? 0 : 70,
                  if (_authMode == AuthMode.signup)
                    FadeTransition(
                      opacity: _opacityAnimation,
                      child: TextFormField(
                          validator: (value) {
                            if (passwordController.text != value) {
                              return 'passwords do not matched';
                            }
                            return null;
                          },
                          decoration:
                              InputDecoration(labelText: 'Confirm password')),
                    ),

                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      _saveForm();
                    },
                    child:
                        Text(_authMode == AuthMode.login ? 'LOGIN' : 'SIGNUP'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  FlatButton(
                      onPressed: () {
                        _switchAuthMode();
                      },
                      child: Text(_authMode == AuthMode.login
                          ? 'SIGNUP INSTEAD'
                          : 'LOGIN INSTEAD'))
                ],
              ),
            ),
          );
  }
}
