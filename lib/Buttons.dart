import 'package:flutter/material.dart';
import 'AppTipografia.dart';
import 'PaletaColores.dart';

// Botón para ir a la siguiente pantalla del creador de personajes.
class BotonSiguiente extends StatelessWidget {
  final VoidCallback onPressed;

  const BotonSiguiente({super.key, required this.onPressed});

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: AppTipografia.subtituloDecorativo(
            color: PaletaColores.fondo,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Siguiente'),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}

// Botón para retroceder a la pantalla anterior.
class BotonAtras extends StatelessWidget {
  final VoidCallback? onPressed;

  const BotonAtras({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: PaletaColores.acentoPrimario,
          side: const BorderSide(color: PaletaColores.acentoPrimario, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: AppTipografia.subtituloDecorativo(
            color: PaletaColores.acentoPrimario,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back),
            SizedBox(width: 8),
            Text('Atrás'),
          ],
        ),
      ),
    );
  }
}

// Botón final para crear el personaje (se usará en la última pantalla).
class BotonCrearPersonaje extends StatelessWidget {
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: AppTipografia.subtituloDecorativo(
            color: PaletaColores.fondo,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: const Text('Crear personaje'),
      ),
    );
  }
}