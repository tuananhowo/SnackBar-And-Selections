import 'package:flutter/material.dart';
import 'package:flutter_13_11/views/test_selection.dart';

import 'views/test_snackbar.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        // ThemeMode themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: const SnackBarWidget(),
        // home: const TestSelection(),
        theme: ThemeData(colorSchemeSeed: Colors.purple, useMaterial3: true),
      ),
    );
  }
}
