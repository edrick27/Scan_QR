import 'package:flutter/material.dart';

import 'package:qr_scanner/src/routes/router.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP Mapas',
      initialRoute: "/",
      routes: getRoutes(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange
      ),
    );
  }
}