import 'package:flutter/material.dart';
import 'package:creador_personaje_rpg/components/Personaje.dart';
import 'package:creador_personaje_rpg/paletas/PaletaColores.dart';
import 'package:creador_personaje_rpg/paletas/AppTipografia.dart';
import 'package:creador_personaje_rpg/components/Buttons.dart';

class Pantalla4 extends StatelessWidget {
  final Map<String, dynamic> datosPrevios;

  const Pantalla4({super.key, this.datosPrevios = const {}});

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

  IconData _iconoClase(String id) {
    switch (id.toLowerCase()) {
      case 'guerrero':
        return Icons.shield;
      case 'mago':
        return Icons.auto_fix_high;
      case 'arquero':
        return Icons.gps_fixed;
      case 'clerigo':
        return Icons.auto_awesome;
      default:
        return Icons.person;
    }
  }

  void _volverAlInicio(BuildContext context) {
    // Reiniciamos los datos del personaje para futuras creaciones
    Personaje.reiniciar();
    Navigator.of(context).popUntil((ruta) => ruta.isFirst);
  }

  void _mostrarDialogoExito(BuildContext context) {
    final nombre = Personaje.nombre.isNotEmpty ? Personaje.nombre : 'Tu personaje';
    final clase = Personaje.claseNombre.isNotEmpty ? Personaje.claseNombre : '';
    final raza = Personaje.razaNombre.isNotEmpty ? Personaje.razaNombre : '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: PaletaColores.superficie,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: PaletaColores.bordePrimario,
              width: 1.5,
            ),
          ),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: PaletaColores.bordePrimario, size: 28),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  '¡PERSONAJE CREADO!',
                  style: AppTipografia.encabezado(
                    color: PaletaColores.bordePrimario,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            '¡Enhorabuena! $nombre el $raza $clase ha sido creado exitosamente y está listo para comenzar la aventura.',
            style: AppTipografia.cuerpo(
              color: PaletaColores.textoPrincipal,
              fontSize: 15,
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: PaletaColores.bordePrimario,
                foregroundColor: PaletaColores.fondo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _volverAlInicio(context);
              },
              child: const Text(
                'FINALIZAR',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
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
          const SizedBox(height: 12),
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
                color: PaletaColores.bordeSecundario,
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
                PaletaColores.bordeSecundario,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nombre = Personaje.nombre.isNotEmpty
        ? Personaje.nombre
        : (datosPrevios['nombre'] as String? ?? 'Héroe sin nombre');
    final biografia = Personaje.biografia.isNotEmpty
        ? Personaje.biografia
        : (datosPrevios['biografia'] as String? ?? '');
    final razaNombre = Personaje.razaNombre.isNotEmpty
        ? Personaje.razaNombre
        : (datosPrevios['razaNombre'] as String? ?? 'Desconocida');
    final razaDescripcion = Personaje.razaDescripcion;
    final claseNombre = Personaje.claseNombre.isNotEmpty
        ? Personaje.claseNombre
        : (datosPrevios['clase'] as String? ?? 'Sin clase');
    final claseDescripcion = Personaje.claseDescripcion;

    return Scaffold(
      backgroundColor: PaletaColores.fondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Encabezado de la Pantalla 4
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: PaletaColores.superficie,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: PaletaColores.bordePrimario,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      _iconoClase(Personaje.claseId),
                      size: 40,
                      color: PaletaColores.bordePrimario,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombre,
                          style: AppTipografia.titularSeccion(
                            fontSize: 22,
                            color: PaletaColores.textoPrincipal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$razaNombre · $claseNombre',
                          style: AppTipografia.subtituloDecorativo(
                            fontSize: 14,
                            color: PaletaColores.bordePrimario,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text('Resumen del Personaje', style: AppTipografia.titularSeccion()),
              const SizedBox(height: 16),

              // 1. Tarjeta: Identidad y Biografía (Datos de Pantalla 1)
              _tarjeta(
                titulo: 'Identidad',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre: $nombre',
                      style: AppTipografia.encabezado(
                        color: PaletaColores.textoPrincipal,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Biografía:',
                      style: AppTipografia.etiqueta(
                        color: PaletaColores.textoSecundario,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      biografia.isNotEmpty
                          ? biografia
                          : 'Sin biografía especificada.',
                      style: AppTipografia.cuerpo(
                        color: biografia.isNotEmpty
                            ? PaletaColores.textoPrincipal
                            : PaletaColores.textoSecundario,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Tarjeta: Raza y Clase (Datos de Pantallas 1 y 2)
              _tarjeta(
                titulo: 'Raza y Clase',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.person,
                          color: PaletaColores.bordePrimario,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Raza: $razaNombre',
                                style: AppTipografia.encabezado(fontSize: 16),
                              ),
                              if (razaDescripcion.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  razaDescripcion,
                                  style: AppTipografia.etiqueta(
                                    color: PaletaColores.textoSecundario,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: PaletaColores.fondo, thickness: 1),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.shield,
                          color: PaletaColores.bordePrimario,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Clase: $claseNombre',
                                style: AppTipografia.encabezado(fontSize: 16),
                              ),
                              if (claseDescripcion.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  claseDescripcion,
                                  style: AppTipografia.etiqueta(
                                    color: PaletaColores.textoSecundario,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. Tarjeta: Atributos Físicos (Datos de Pantalla 2 / 3)
              _tarjeta(
                titulo: 'Atributos físicos',
                child: Column(children: fisicos.map(_filaAtributo).toList()),
              ),

              // 4. Tarjeta: Atributos Mentales (Datos de Pantalla 3)
              _tarjeta(
                titulo: 'Atributos mentales',
                child: Column(children: mentales.map(_filaAtributo).toList()),
              ),

              // 5. Tarjeta: Equipamiento (Datos de Pantalla 3)
              _tarjeta(
                titulo: 'Equipamiento',
                child: Personaje.equipados.isEmpty
                    ? Text(
                        'Sin objetos equipados.',
                        style: AppTipografia.cuerpo(
                          color: PaletaColores.textoSecundario,
                        ),
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
                                        style: AppTipografia.encabezado(fontSize: 15),
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

              const SizedBox(height: 12),

              // Botón Final: Crear Personaje
              BotonCrearPersonaje(
                onPressed: () => _mostrarDialogoExito(context),
              ),
              const SizedBox(height: 10),

              // Botón Atrás: Permite volver a la Pantalla 3 para modificar datos
              BotonAtras(
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
