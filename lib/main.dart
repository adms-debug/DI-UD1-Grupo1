import 'package:creador_personaje_rpg/pantallas/pantalla3.dart';
import 'package:flutter/material.dart';

import 'CrearPersonaje.dart';
import 'package:creador_personaje_rpg/CrearPersonaje.dart';

import 'pantalla1.dart';

import 'package:creador_personaje_rpg/CrearPersonaje.dart';

import 'pantallas/pantalla2.dart';

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
      home: Pantalla2(),
      home: Pantalla3(),
    );
  }
}
