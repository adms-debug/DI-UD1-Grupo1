import 'package:flutter/material.dart';
import 'package:creador_personaje_rpg/components/AtributoItem.dart';
import 'package:creador_personaje_rpg/components/InventarioItem.dart';
import 'package:creador_personaje_rpg/PaletaColores.dart';
import 'package:creador_personaje_rpg/AppTipografia.dart';

class Pantalla3 extends StatelessWidget {
  const Pantalla3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaletaColores.fondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: PaletaColores.superficie,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: PaletaColores.acentoPrimario,
                        width: 1.5,
                      ),
                    ),

                    child: const Icon(
                      Icons.auto_fix_high,
                      size: 40,
                      color: PaletaColores.textoPrincipal,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NOMBRE', style: AppTipografia.titularSeccion()),
                      SizedBox(height: 2),
                      Text(
                        'Nivel 14 - Hechizero Arcano',
                        style: AppTipografia.subtituloDecorativo(),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Atributos', style: AppTipografia.titularSeccion()),
              SizedBox(height: 20),

              //Puntos para asignar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: PaletaColores.superficie,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: PaletaColores.acentoPrimario,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Puntos para Asignar',
                      style: AppTipografia.encabezado(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: PaletaColores.acentoPrimario,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '5 PTOS',
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              const AtributoItem(
                titulo: 'INTELECTO',
                icono: Icons.book,
                valor: '18',
                progreso: 0.7,
              ),
              const AtributoItem(
                titulo: 'SABIDURÍA',
                icono: Icons.remove_red_eye,
                valor: '14',
                progreso: 0.5,
              ),
              const AtributoItem(
                titulo: 'VOLUNTAD',
                icono: Icons.shield,
                valor: '16',
                progreso: 0.6,
              ),
              const AtributoItem(
                titulo: 'PERCEPCIÓN',
                icono: Icons.explore,
                valor: '12',
                progreso: 0.4,
              ),
              const AtributoItem(
                titulo: 'CONCENTRACIÓN',
                icono: Icons.hourglass_empty,
                valor: '10',
                progreso: 0.3,
              ),

              SizedBox(height: 30),

              //Equipamiento
              Text('Inventario', style: AppTipografia.titularSeccion()),

              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const InventarioItem(
                    titulo: 'ARMA',
                    icono: Icons.edit,
                    subtitulo: '',
                  ),
                  const InventarioItem(
                    titulo: 'ARMADURA',
                    icono: Icons.shield,
                    subtitulo: '',
                  ),
                  const InventarioItem(
                    titulo: 'AMULETO',
                    icono: Icons.military_tech,
                    subtitulo: '',
                  ),
                  const InventarioItem(
                    titulo: 'ANILLO',
                    icono: Icons.grid_view,
                    subtitulo: '',
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PaletaColores.acentoPrimario,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.check_circle_outline,
                        color: PaletaColores.superficie,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'GUARDAR EQUIPAMIENTO',
                        style: TextStyle(
                          color: PaletaColores.superficie,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
