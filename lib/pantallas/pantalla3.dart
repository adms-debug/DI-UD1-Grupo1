import 'package:flutter/material.dart';
import 'package:creador_personaje_rpg/componentes%20pantalla3/AtributoItem.dart';
import 'package:creador_personaje_rpg/componentes%20pantalla3/InventarioItem.dart';
import 'package:creador_personaje_rpg/componentes pantalla3/ObjetoModelo.dart';
import 'package:creador_personaje_rpg/PaletaColores.dart';
import 'package:creador_personaje_rpg/AppTipografia.dart';
import 'package:creador_personaje_rpg/Buttons.dart';
import 'package:creador_personaje_rpg/pantalla1.dart';
import 'package:creador_personaje_rpg/pantallas/pantalla4.dart';
import 'package:creador_personaje_rpg/Personaje.dart';

import 'dart:convert';

import 'package:flutter/services.dart';

class Pantalla3 extends StatefulWidget {
  const Pantalla3({super.key});

  @override
  State<Pantalla3> createState() => Pantalla3State();
}

class Pantalla3State extends State<Pantalla3> {
  //Puntos y atributos
  int puntosDisponibles = 5;

  //Los atributos no se pueden bajar de 10
  final Map<String, int> atributosBase = {
    'fuerza': 10,
    'destreza': 10,
    'constitucion': 10,
    'inteligencia': 10,
    'sabiduria': 10,
    'carisma': 10,
  };
  late final Map<String, int> atributos = Map.of(atributosBase);

  static const Map<String, String> titulos = {
    'fuerza': 'FUERZA',
    'destreza': 'DESTREZA',
    'constitucion': 'CONSTITUCIÓN',
    'inteligencia': 'INTELIGENCIA',
    'sabiduria': 'SABIDURÍA',
    'carisma': 'CARISMA',
  };

  static const Map<String, IconData> iconosAtributo = {
    'fuerza': Icons.fitness_center,
    'destreza': Icons.bolt,
    'constitucion': Icons.shield,
    'inteligencia': Icons.book,
    'sabiduria': Icons.remove_red_eye,
    'carisma': Icons.favorite,
  };

  List<ObjetoModelo> objetos = [];
  final Set<String> equipados = {};
  ObjetoModelo? objetoSeleccionado;
  String? descripcionSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarObjetos();
  }

  Future<void> _cargarObjetos() async {
    final texto = await rootBundle.loadString('assets/data/objetos.json');
    final lista = jsonDecode(texto) as List<dynamic>;
    if (!mounted) return;
    setState(() {
      objetos = lista.map((e) => ObjetoModelo.fromJson(e)).toList();
    });
  }

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

  // Recorre los objetos y suma los bonificadores de los equipados para un atributo
  int _bonus(String clave) {
    int suma = 0;
    for (final o in objetos) {
      if (equipados.contains(o.id)) {
        suma += o.bonificadores[clave] ?? 0;
      }
    }
    return suma;
  }

  //Metodo para guardar los datos seleccionados y pasar a la pantalla 4
  void _guardarYContinuar() {
    Personaje.atributos = {
      for (final k in atributos.keys) k: atributos[k]! + _bonus(k),
    };
    Personaje.equipados = objetos
        .where((o) => equipados.contains(o.id))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Pantalla4()),
    );
  }

  //Crea un los atributos usando la clase AtributoItem
  Widget _construirAtributo(String clave) {
    final total = atributos[clave]! + _bonus(clave);
    return AtributoItem(
      titulo: titulos[clave]!,
      icono: iconosAtributo[clave]!,
      valor: '$total',
      progreso: (total / 30).clamp(0.0, 1.0),
      onIncrement: () {
        if (puntosDisponibles > 0 && total < 30) {
          setState(() {
            puntosDisponibles--;
            atributos[clave] = atributos[clave]! + 1;
          });
        }
      },
      onDecrement: () {
        if (atributos[clave]! > atributosBase[clave]!) {
          setState(() {
            puntosDisponibles++;
            atributos[clave] = atributos[clave]! - 1;
          });
        }
      },
    );
  }

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
              //Icono nombre y título
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
                      Text('Nombre', style: AppTipografia.titularSeccion()),
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
                    color: PaletaColores.bordePrimario,
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
                          color: PaletaColores.bordePrimario,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$puntosDisponibles PTOS',
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              //Atributos usando el componente AtributoItem de AtributoItem.dart
              ...titulos.keys.map(_construirAtributo),

              SizedBox(height: 30),

              //Equipamiento
              Text('Inventario', style: AppTipografia.titularSeccion()),

              SizedBox(height: 20),

              //Widget que sale cuando se selecciona un objeto
              if (objetoSeleccionado != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: PaletaColores.superficie,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: PaletaColores.bordePrimario,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ' ${objetoSeleccionado!.nombre}',
                            style: AppTipografia.titularSeccion(),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                objetoSeleccionado = null; //oculta la tarjeta si no hay ningun objeto seleccionado
                              });
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        descripcionSeleccionada ?? '',
                        style: AppTipografia.cuerpo(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],

              //Objetos usando el componente InventarioItem de InventarioItem.dart
              Column(
                children: objetos.map((o) {
                  return InventarioItem(
                    titulo: o.nombre.toUpperCase(),
                    icono: _iconoPorTipo(o.tipo),
                    subtitulo: o.tipo,
                    equipado: equipados.contains(o.id),
                    onTap: () {
                      setState(() {
                        objetoSeleccionado = o;
                        descripcionSeleccionada = o.descripcion;
                      });
                    },
                    onEquip: () {
                      setState(() {
                        objetoSeleccionado = o;
                        if (equipados.contains(o.id)) {
                          equipados.remove(o.id);
                          descripcionSeleccionada =
                              'Has desequipado ${o.nombre}.';
                        } else {
                          equipados.add(o.id);
                          descripcionSeleccionada =
                              '¡Has equipado ${o.nombre}!';
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

              //Botón Guardar Equipamiento usando el elemento de buttons.dart
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BotonFinal(
                  texto: 'Crear Personaje',
                  onPressed: _guardarYContinuar,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
