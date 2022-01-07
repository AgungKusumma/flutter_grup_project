import 'package:flutter/material.dart';

void main() => runApp(
    AdminHome()
);

class AdminHome extends StatefulWidget{
  _AdminHome createState() => _AdminHome();
}

class _AdminHome extends State<AdminHome>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Home'),
      ],
    );
  }

}