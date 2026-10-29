import 'package:flutter/material.dart';
import 'package:creador_personaje_rpg/Personaje.dart';
import 'package:creador_personaje_rpg/PaletaColores.dart';
import 'package:creador_personaje_rpg/AppTipografia.dart';
import 'package:creador_personaje_rpg/Buttons.dart';

class Pantalla4 extends StatelessWidget {
  const Pantalla4({super.key});

  static const Map<String, String> titulos = {
    'fuerza': 'FUERZA',
    'destreza': 'DESTREZA',
    'constitucion': 'CONSTITUCIÓN',
    'inteligencia': 'INTELIGENCIA',
    'sabiduria': 'SABIDURÍA',
    'carisma': 'CARISMA',
  };

  static const Map<String, IconData> iconos = {
    'fuerza': Icons.fitness_center,
    'destreza': Icons.bolt,
    'constitucion': Icons.shield,
    'inteligencia': Icons.book,
    'sabiduria': Icons.remove_red_eye,
    'carisma': Icons.favorite,
  };

  static const List<String> fisicos = ['fuerza', 'destreza', 'constitucion'];
  static const List<String> mentales = ['inteligencia', 'sabiduria', 'carisma'];

  IconData _iconoPorTipo(String tipo) {
    switch (tipo) {
      case 'Arma':
        return Icons.gavel;
      case 'Defensa':
        return Icons.shield;
      default:
        return Icons.inventory_2;
    }
  }

  void _volverAlInicio(BuildContext context) {
    Navigator.of(context).popUntil((ruta) => ruta.isFirst);
  }

  Widget _tarjeta({required String titulo, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PaletaColores.superficie,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PaletaColores.bordePrimario, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: AppTipografia.titularSeccion()),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _filaAtributo(String clave) {
    final valor = Personaje.atributos[clave] ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                iconos[clave],
                color: PaletaColores.acentoSecundario,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(titulos[clave]!, style: AppTipografia.encabezado()),
              ),
              Text('$valor', style: AppTipografia.encabezado()),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (valor / 30).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: PaletaColores.fondo,
              valueColor: const AlwaysStoppedAnimation<Color>(
                PaletaColores.acentoSecundario,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaletaColores.fondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Resumen', style: AppTipografia.titularSeccion()),
              const SizedBox(height: 20),

              _tarjeta(
                titulo: 'Atributos físicos',
                child: Column(children: fisicos.map(_filaAtributo).toList()),
              ),

              _tarjeta(
                titulo: 'Atributos mentales',
                child: Column(children: mentales.map(_filaAtributo).toList()),
              ),

              _tarjeta(
                titulo: 'Equipamiento',
                child: Personaje.equipados.isEmpty
                    ? Text(
                        'Sin objetos equipados.',
                        style: AppTipografia.cuerpo(),
                      )
                    : Column(
                        children: Personaje.equipados.map((o) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Icon(
                                  _iconoPorTipo(o.tipo),
                                  color: PaletaColores.bordePrimario,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        o.nombre.toUpperCase(),
                                        style: AppTipografia.encabezado(),
                                      ),
                                      Text(
                                        o.descripcion,
                                        style: AppTipografia.etiqueta(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),

              const SizedBox(height: 8),

              // Vuelve a Pantalla3, que conserva su estado
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BotonFinal(
                  texto: 'Modificar',
                  onPressed: () => _volverAlInicio(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
