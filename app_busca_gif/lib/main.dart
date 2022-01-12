import 'package:flutter/material.dart';
import 'package:app_busca_gif/ui/gif_page.dart';
import 'package:app_busca_gif/ui/HomePage.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
      theme: ThemeData(hintColor: Colors.white),
      debugShowCheckedModeBanner: false,
    ),
  );
}


