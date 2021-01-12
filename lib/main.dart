import 'package:flutter/material.dart';
import 'package:flutter_band_names/src/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grupos de música',
      initialRoute: '/',
      routes: {
        '/': (_) => HomeScreen()
      },
    );
  }
}
