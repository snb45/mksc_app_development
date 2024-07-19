import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mksc_mobile/screens/homescreen.dart';
import 'package:mksc_mobile/screens/viewuploadeddata.dart';
import 'package:mksc_mobile/modals/menu_modal.dart';

import 'screens/menuscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuModel()),
      ],
      child: MaterialApp(
        title: 'MKSC APP',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/getdata': (context) => const GetData(tokenExpired: false),
          '/menu': (context) => const MenuScreen(),
        },
      ),
    );
  }
}
