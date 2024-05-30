import 'package:flutter/material.dart';
import 'package:mksc_mobile/screens/homescreen.dart';
import 'package:mksc_mobile/screens/viewuploadeddata.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mksc mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/', 
      routes: {
        '/': (context) => const HomeScreen(), 
        '/getdata': (context) => const GetData(tokenExpired: false),
      },
    );
  }
}
