import 'package:flutter/material.dart';
import 'package:flutter_band_names/src/screens/home_screen.dart';
import 'package:flutter_band_names/src/screens/status_screen.dart';
import 'package:flutter_band_names/src/services/socket_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Grupos de música',
        initialRoute: 'home',
        routes: {
          '/': (_) => HomeScreen(),
          'status': (_) => StatusScreen()
        },
      ),
    );
  }
}
