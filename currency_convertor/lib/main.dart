import 'package:currency_convertor/currency_convertor_cupertino_page.dart';
import 'package:currency_convertor/currency_convertor_material_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  // runApp(const MyApp());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  // const MyApp({Key? key}): super(key : key); == ⬇
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {  
    return MaterialApp(
      title: 'Currency Convertor App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MaterialHomePage(),
    );
  }
}

class MyCupertinoApp extends StatelessWidget {
  const MyCupertinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: CurrencyConvertorCupertinoPage(),
    );
  }
}