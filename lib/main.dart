import 'package:buscaminas/buscaminas.dart';
import 'package:flutter/material.dart';
import 'package:buscaminas/constantes.dart' as cons;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buscaminas',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: cons.Princ),
      ),
      home: const Buscaminas(),
    );
  }
}
