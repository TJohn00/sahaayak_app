import 'package:flutter/material.dart';
import 'package:sahaayak_app/Customer/components/MainMenu.dart';
import 'package:sahaayak_app/Shared/screens/Register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sahaayak',
      home: RegisterPage(),
    );
  }
}
