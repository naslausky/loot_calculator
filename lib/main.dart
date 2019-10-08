import 'package:flutter/material.dart';
import 'telaValores.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de loot',
      theme: ThemeData.dark(),
      home: TelaValores(),
      debugShowCheckedModeBanner: false,
    );
  }
}
