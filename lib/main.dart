import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:quran/pages/homepage.dart';
import 'package:quran/services/managment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main()async {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>ThemeProvider()..initTheme(),
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            themeMode: value.isToggle?ThemeMode.dark:ThemeMode.light,
            darkTheme: value.isToggle?value.darkTheme:value.lightTheme,
            home: const Home(),
          );
        },

      ),
    );
  }
}

