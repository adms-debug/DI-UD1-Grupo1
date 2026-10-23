import 'package:creador_personaje_rpg/AppTipografia.dart';
import 'package:creador_personaje_rpg/PaletaColores.dart';
import 'package:flutter/material.dart';

class Pantalla1 extends StatelessWidget {
  const Pantalla1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: PaletaColores.fondo),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pantalla 1',
              style: AppTipografia.titularSeccion().copyWith(
                color: PaletaColores.textoPrincipal,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
