import 'package:flutter/material.dart';
import 'package:creador_personaje_rpg/componentes%20pantalla3/AtributoItem.dart';
import 'package:creador_personaje_rpg/componentes%20pantalla3/InventarioItem.dart';
import 'package:creador_personaje_rpg/PaletaColores.dart';
import 'package:creador_personaje_rpg/AppTipografia.dart';
import 'package:creador_personaje_rpg/Buttons.dart';

class Pantalla3 extends StatefulWidget {
  const Pantalla3({super.key});

  @override
  State<Pantalla3> createState() => Pantalla3State();
}

class Pantalla3State extends State<Pantalla3> {
  //Puntos y atributos
  int puntosDisponibles = 5;

  int intelecto = 18;
  final int intelectoBase = 18;

  int sabiduria = 14;
  final int sabiduriaBase = 14;

  int voluntad = 16;
  final int voluntadBase = 16;

  int percepcion = 12;
  final int percepcionBase = 12;

  int concentracion = 10;
  final int concentracionBase = 10;

  //Variables de estado para saber cual está equipado
  bool armaEquipada = true;
  bool armaduraEquipada = false;
  bool amuletoEquipado = false;
  bool anilloEquipado = false;

  //Variables para mostrar información del objeto seleccionado
  String? objetoSeleccionado;
  String? descripcionSeleccionada;

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
              AtributoItem(
                titulo: 'INTELECTO',
                icono: Icons.book,
                valor: '$intelecto',
                progreso: (intelecto / 30).clamp(0.0, 1.0),
                onIncrement: () {
                  if (puntosDisponibles > 0 && intelecto < 30) {
                    setState(() {
                      puntosDisponibles--;
                      intelecto++;
                    });
                  }
                },
                onDecrement: () {
                  if (intelecto > 0) {
                    setState(() {
                      puntosDisponibles++;
                      intelecto--;
                    });
                  }
                },
              ),

              AtributoItem(
                titulo: 'SABIDURÍA',
                icono: Icons.remove_red_eye,
                valor: '$sabiduria',
                progreso: (sabiduria / 30).clamp(0.0, 1.0),
                onIncrement: () {
                  if (puntosDisponibles > 0 && sabiduria < 30) {
                    setState(() {
                      puntosDisponibles--;
                      sabiduria++;
                    });
                  }
                },
                onDecrement: () {
                  if (sabiduria > 0) {
                    setState(() {
                      puntosDisponibles++;
                      sabiduria--;
                    });
                  }
                },
              ),

              AtributoItem(
                titulo: 'VOLUNTAD',
                icono: Icons.shield,
                valor: '$voluntad',
                progreso: (voluntad / 30).clamp(0.0, 1.0),
                onIncrement: () {
                  if (puntosDisponibles > 0 && voluntad < 30) {
                    setState(() {
                      puntosDisponibles--;
                      voluntad++;
                    });
                  }
                },
                onDecrement: () {
                  if (voluntad > 0) {
                    setState(() {
                      puntosDisponibles++;
                      voluntad--;
                    });
                  }
                },
              ),

              AtributoItem(
                titulo: 'PERCEPCIÓN',
                icono: Icons.explore,
                valor: '$percepcion',
                progreso: (percepcion / 30).clamp(0.0, 1.0),
                onIncrement: () {
                  if (puntosDisponibles > 0 && percepcion < 30) {
                    setState(() {
                      puntosDisponibles--;
                      percepcion++;
                    });
                  }
                },
                onDecrement: () {
                  if (percepcion > 0) {
                    setState(() {
                      puntosDisponibles++;
                      percepcion--;
                    });
                  }
                },
              ),

              AtributoItem(
                titulo: 'CONCENTRACIÓN',
                icono: Icons.hourglass_empty,
                valor: '$concentracion',
                progreso: (concentracion / 30).clamp(0.0, 1.0),
                onIncrement: () {
                  if (puntosDisponibles > 0 && concentracion < 30) {
                    setState(() {
                      puntosDisponibles--;
                      concentracion++;
                    });
                  }
                },
                onDecrement: () {
                  if (concentracion > 0) {
                    setState(() {
                      puntosDisponibles++;
                      concentracion--;
                    });
                  }
                },
              ),

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
                      color: PaletaColores.acentoPrimario,
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
                            'Detalles: $objetoSeleccionado',
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InventarioItem(
                    titulo: 'ARMA',
                    icono: Icons.edit,
                    subtitulo: '',
                    equipado: armaEquipada,
                    onTap: () {
                      setState(() {
                        objetoSeleccionado = 'ARMA';
                        descripcionSeleccionada = 'Arma';
                      });
                    },
                    onEquip: () {
                      setState(() {
                        objetoSeleccionado = 'ARMA';
                        armaEquipada = !armaEquipada;
                        descripcionSeleccionada = armaduraEquipada
                            ? '¡Has equipado el arma!'
                            : 'Has desequipado el arma.';
                      });
                    },
                  ),
                  InventarioItem(
                    titulo: 'ARMADURA',
                    icono: Icons.shield,
                    subtitulo: '',
                    equipado: armaduraEquipada,
                    onTap: () {
                      setState(() {
                        objetoSeleccionado = 'ARMADURA';
                        descripcionSeleccionada = 'Aramadura';
                      });
                    },
                    onEquip: () {
                      setState(() {
                        objetoSeleccionado = 'ARMADURA';
                        armaduraEquipada = !armaduraEquipada;
                        descripcionSeleccionada = armaduraEquipada
                            ? '¡Has equipado la armadura!'
                            : 'Has desequipado la armadura.';
                      });
                    },
                  ),
                  InventarioItem(
                    titulo: 'AMULETO',
                    icono: Icons.military_tech,
                    subtitulo: 'ss',
                    equipado: amuletoEquipado,
                    onTap: () {
                      setState(() {
                        objetoSeleccionado = 'AMULETO';
                        descripcionSeleccionada = 'Amuleto';
                      });
                    },
                    onEquip: () {
                      setState(() {
                        objetoSeleccionado = 'AMULETO';
                        amuletoEquipado = !amuletoEquipado;
                        descripcionSeleccionada = armaduraEquipada
                            ? '¡Has equipado el amuleto!'
                            : 'Has desequipado el amuleto.';
                      });
                    },
                  ),
                  InventarioItem(
                    titulo: 'ANILLO',
                    icono: Icons.grid_view,
                    subtitulo: '',
                    equipado: anilloEquipado,
                    onTap: () {
                      setState(() {
                        objetoSeleccionado = 'ANILLO';
                        descripcionSeleccionada = 'Anillo';
                      });
                    },
                    onEquip: () {
                      setState(() {
                        objetoSeleccionado = 'ANILLO';
                        anilloEquipado = !anilloEquipado;
                        descripcionSeleccionada = armaduraEquipada
                            ? '¡Has equipado el anillo!'
                            : 'Has desequipado el anillo.';
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              //Botón Guardar Equipamiento usando el elemento de buttons.dart
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BotonCrearPersonaje(
                  onPressed: () {
                    print("Boton pulsado");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
