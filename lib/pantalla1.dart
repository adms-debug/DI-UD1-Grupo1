import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:creador_personaje_rpg/components/RazaItem.dart';
import 'package:creador_personaje_rpg/PaletaColores.dart';
import 'package:creador_personaje_rpg/AppTipografia.dart';

class Pantalla1 extends StatefulWidget {
  const Pantalla1({super.key});

  @override
  State<Pantalla1> createState() => _Pantalla1State();
}

class _Pantalla1State extends State<Pantalla1> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _biografiaController = TextEditingController();

  //Variables para la lectura de datos del JSON
  List<Map<String, dynamic>> razas = [];
  bool cargando = true;
  String? mensajeError;

  //Índice de la raza seleccionada (-1 si ninguna está seleccionada)
  int? razaSeleccionadaIndex;

  @override
  void initState() {
    super.initState();
    cargarRazas();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _biografiaController.dispose();
    super.dispose();
  }

  //Carga asíncrona de razas desde el archivo JSON de assets
  Future<void> cargarRazas() async {
    try {
      //1. Leemos el archivo JSON como texto
      final texto = await rootBundle.loadString('assets/data/razas.json');

      //2. Convertimos el texto JSON a datos de Dart
      final datos = jsonDecode(texto) as List<dynamic>;

      //3. Convertimos cada elemento de la lista en un Map
      final razasCargadas = datos
          .map((elemento) => Map<String, dynamic>.from(elemento as Map))
          .toList();

      //4. Actualizamos el estado cuando termina la lectura
      if (!mounted) return;
      setState(() {
        razas = razasCargadas;
        cargando = false;
        mensajeError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        mensajeError = 'No se pudieron cargar las razas: $error';
        cargando = false;
      });
    }
  }

  //Asigna un icono temático según el ID de la raza
  IconData _obtenerIcono(String id) {
    switch (id.toLowerCase()) {
      case 'humano':
        return Icons.person;
      case 'elfo':
        return Icons.auto_awesome;
      case 'enano':
        return Icons.shield;
      case 'orco':
        return Icons.fitness_center;
      default:
        return Icons.person_outline;
    }
  }

  void _irASiguiente() {
    final nombre = _nombreController.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: PaletaColores.alerta,
          content: Text('Por favor, escribe un nombre para tu personaje.'),
        ),
      );
      return;
    }

    if (razaSeleccionadaIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: PaletaColores.alerta,
          content: Text('Por favor, selecciona una raza.'),
        ),
      );
      return;
    }

    final razaElegida = razas[razaSeleccionadaIndex!];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PaletaColores.superficie,
        content: Text(
          '¡Datos guardados! Personaje: $nombre | Raza: ${razaElegida['nombre']}',
          style: const TextStyle(color: PaletaColores.bordePrimario),
        ),
      ),
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
              //Encabezado superior
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
                      Icons.shield,
                      size: 40,
                      color: PaletaColores.textoPrincipal,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CREACIÓN', style: AppTipografia.titularSeccion()),
                      const SizedBox(height: 2),
                      Text(
                        'Paso 1 - Identidad y Raza',
                        style: AppTipografia.subtituloDecorativo(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bloque: Identidad del personaje
              Text('Identidad', style: AppTipografia.titularSeccion()),
              const SizedBox(height: 20),

              // Campo Nombre
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre del Personaje',
                      style: AppTipografia.etiqueta(
                        color: PaletaColores.textoSecundario,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _nombreController,
                      style: AppTipografia.cuerpo(
                        color: PaletaColores.textoPrincipal,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Introduce el nombre...',
                        hintStyle: TextStyle(
                          color: PaletaColores.textoSecundario,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Campo Biografía
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Biografía',
                      style: AppTipografia.etiqueta(
                        color: PaletaColores.textoSecundario,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _biografiaController,
                      maxLines: 3,
                      style: AppTipografia.cuerpo(
                        color: PaletaColores.textoPrincipal,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Escribe una breve historia...',
                        hintStyle: TextStyle(
                          color: PaletaColores.textoSecundario,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Bloque: Razas desde el archivo JSON
              Text('Razas', style: AppTipografia.titularSeccion()),
              const SizedBox(height: 20),

              _construirListaRazas(),

              const SizedBox(height: 20),

              // Botón Siguiente pantalla
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PaletaColores.bordePrimario,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _irASiguiente,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.arrow_forward,
                        color: PaletaColores.superficie,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'SIGUIENTE',
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

  // Construye la lista dinámica de razas gestionando los estados (cargando, error o lista)
  Widget _construirListaRazas() {
    if (cargando) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(color: PaletaColores.bordePrimario),
        ),
      );
    }

    if (mensajeError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                mensajeError!,
                style: const TextStyle(color: PaletaColores.alerta),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: cargarRazas,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (razas.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'No hay razas disponibles.',
            style: TextStyle(color: PaletaColores.textoPrincipal),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: razas.length,
      itemBuilder: (context, index) {
        final raza = razas[index];
        final bool seleccionada = razaSeleccionadaIndex == index;

        return RazaItem(
          titulo: (raza['nombre'] as String? ?? '').toUpperCase(),
          subtitulo: raza['descripcion'] as String? ?? '',
          icono: _obtenerIcono(raza['id'] as String? ?? ''),
          seleccionada: seleccionada,
          onTap: () {
            setState(() {
              razaSeleccionadaIndex = index;
            });
          },
        );
      },
    );
  }
}
