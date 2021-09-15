import 'package:flutter/material.dart';
import 'package:services_controll_app/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Services Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue
      ),
      initialRoute: '/login',
      routes: routes,
    );
  }
}
