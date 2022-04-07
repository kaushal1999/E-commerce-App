import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  Badge({
    required this.child,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 5,
          right: 5,
          child: CircleAvatar(
            radius: 10,
            child: Text(value),
            backgroundColor: Theme.of(context).accentColor,
          ),
        )
      ],
    );
  }
}
