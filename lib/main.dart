import 'package:flutter/material.dart';
import 'package:creador_personaje_rpg/pantallas/pantalla1.dart';

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
      home: Pantalla1(),
    );
  }
}
