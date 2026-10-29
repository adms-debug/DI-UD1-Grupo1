import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:creador_personaje_rpg/components/AtributoItem.dart';
import 'package:creador_personaje_rpg/components/InventarioItem.dart';
import 'package:creador_personaje_rpg/components/ObjetoModelo.dart';
import 'package:creador_personaje_rpg/paletas/PaletaColores.dart';
import 'package:creador_personaje_rpg/paletas/AppTipografia.dart';
import 'package:creador_personaje_rpg/components/Buttons.dart';
import 'package:creador_personaje_rpg/pantallas/pantalla4.dart';
import 'package:creador_personaje_rpg/components/Personaje.dart';

class Pantalla3 extends StatefulWidget {
  final Map<String, dynamic> datosPrevios;

  const Pantalla3({super.key, this.datosPrevios = const {}});

  @override
  State<Pantalla3> createState() => Pantalla3State();
}

class Pantalla3State extends State<Pantalla3> {
  int puntosDisponibles = 5;

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
    if (Personaje.atributosFisicos.isNotEmpty) {
      for (final k in ['fuerza', 'destreza', 'constitucion']) {
        if (Personaje.atributosFisicos.containsKey(k)) {
          atributosBase[k] = Personaje.atributosFisicos[k]!;
          atributos[k] = Personaje.atributosFisicos[k]!;
        }
      }
    }

    for (final obj in Personaje.equipados) {
      equipados.add(obj.id);
    }
    _cargarObjetos();
  }

  Future<void> _cargarObjetos() async {
    try {
      final texto = await rootBundle.loadString('assets/data/objetos.json');
      final lista = jsonDecode(texto) as List<dynamic>;
      if (!mounted) return;
      setState(() {
        objetos = lista.map((e) => ObjetoModelo.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint('Error al cargar objetos: $e');
    }
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

  IconData _obtenerIconoClase(String id) {
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

  int _bonus(String clave) {
    int suma = 0;
    for (final o in objetos) {
      if (equipados.contains(o.id)) {
        suma += o.bonificadores[clave] ?? 0;
      }
    }
    return suma;
  }

  void _guardarYContinuar() {
    Personaje.atributos = {
      for (final k in atributos.keys) k: atributos[k]! + _bonus(k),
    };
    Personaje.equipados = objetos
        .where((o) => equipados.contains(o.id))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Pantalla4(datosPrevios: widget.datosPrevios),
      ),
    );
  }

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
    final nombrePersonaje = Personaje.nombre.isNotEmpty ? Personaje.nombre : 'Héroe';
    final razaPersonaje = Personaje.razaNombre.isNotEmpty ? Personaje.razaNombre : 'Aventurero';
    final clasePersonaje = Personaje.claseNombre.isNotEmpty ? Personaje.claseNombre : 'Sin clase';

    return Scaffold(
      backgroundColor: PaletaColores.fondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: PaletaColores.superficie,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: PaletaColores.bordePrimario, width: 1.5),
                    ),
                    child: Icon(_obtenerIconoClase(Personaje.claseId), size: 40, color: PaletaColores.textoPrincipal),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nombrePersonaje, style: AppTipografia.titularSeccion(), overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text('$razaPersonaje · $clasePersonaje', style: AppTipografia.subtituloDecorativo(fontSize: 14, color: PaletaColores.textoSecundario), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Atributos', style: AppTipografia.titularSeccion()),
              const SizedBox(height: 20),
              ...titulos.keys.map(_construirAtributo),
              const SizedBox(height: 30),
              Text('Inventario', style: AppTipografia.titularSeccion()),
              const SizedBox(height: 20),
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
                        } else {
                          equipados.add(o.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              BotonSiguiente(onPressed: _guardarYContinuar),
              const SizedBox(height: 10),
              BotonAtras(onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}