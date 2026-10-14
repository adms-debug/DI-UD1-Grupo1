import 'package:flutter/material.dart';
import 'CrearPersonaje.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Creador de personajes',
      home: CrearPersonaje(),
    );
  }
}