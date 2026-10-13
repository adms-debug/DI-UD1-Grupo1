import 'package:flutter/material.dart';
import 'PaletaColores.dart';

class BotonCrearPersonaje extends StatelessWidget {
  //Función que se ejecutará al pulsar. Se la pasa quien use el botón.
  final VoidCallback onPressed;

  const BotonCrearPersonaje({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: PaletaColores.acentoPrimario,
          foregroundColor: PaletaColores.fondo,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 18),
        ),
        child: const Text('Crear personaje'),
      ),
    );
  }
}