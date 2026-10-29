import 'package:flutter/material.dart';
import '../paletas/AppTipografia.dart';
import '../paletas/PaletaColores.dart';

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
          backgroundColor: PaletaColores.bordePrimario,
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
          foregroundColor: PaletaColores.bordePrimario,
          side: const BorderSide(
            color: PaletaColores.bordePrimario,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: AppTipografia.subtituloDecorativo(
            color: PaletaColores.bordePrimario,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.arrow_back), SizedBox(width: 8), Text('Atrás')],
        ),
      ),
    );
  }
}

// Botón final para crear el personaje (se usará en la última pantalla).
class BotonCrearPersonaje extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const BotonCrearPersonaje({super.key, required this.texto, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: PaletaColores.bordePrimario,
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
        child: Text(texto),
      ),
    );
  }
}
