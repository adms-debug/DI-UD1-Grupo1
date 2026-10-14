import 'package:flutter/material.dart';
import 'PaletaColores.dart';
import 'AppTipografia.dart';
import 'buttons.dart';

//Pantalla para crear un personaje RPG.
//Tiene un campo de texto (nombre), tarjetas de selección (raza) y un botón.
class CrearPersonaje extends StatefulWidget {
  const CrearPersonaje({super.key});

  @override
  State<CrearPersonaje> createState() => _CrearPersonajeState();
}

class _CrearPersonajeState extends State<CrearPersonaje> {
  final TextEditingController _nombreController = TextEditingController();

  //Raza elegida en las tarjetas. Empieza en null: aún no hay ninguna.
  String? _raza;

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _crear() {
    print('Personaje creado: ${_nombreController.text}, raza: $_raza');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaletaColores.fondo,
      appBar: AppBar(
        backgroundColor: PaletaColores.superficie,
        centerTitle: true,
        //Encabezado: icono temático + título estilizado, en un Row centrado.
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shield, color: PaletaColores.acentoPrimario),
            const SizedBox(width: 10),
            Text(
              'Crear personaje',
              style: AppTipografia.titularMagno(
                color: PaletaColores.acentoPrimario,
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nombreController,
              style: AppTipografia.cuerpo(color: PaletaColores.textoPrincipal),
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle:
                    AppTipografia.etiqueta(color: PaletaColores.textoSecundario),
                filled: true,
                fillColor: PaletaColores.superficie,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: PaletaColores.acentoPrimario,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: PaletaColores.acentoPrimario,
                    width: 2.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Raza',
              style: AppTipografia.titularSeccion(
                color: PaletaColores.acentoPrimario,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            SelectorRaza(
              onChanged: (raza) => _raza = raza,
            ),
            const SizedBox(height: 24),
            BotonCrearPersonaje(onPressed: _crear),
          ],
        ),
      ),
    );
  }
}

//Selector de raza con tarjetas.
//Es StatefulWidget porque necesita recordar cuál está seleccionada.
class SelectorRaza extends StatefulWidget {
  //Avisa a la pantalla padre de la raza elegida.
  final ValueChanged<String>? onChanged;

  const SelectorRaza({super.key, this.onChanged});

  @override
  State<SelectorRaza> createState() => _SelectorRazaState();
}

class _SelectorRazaState extends State<SelectorRaza> {
  final List<String> _razas = ['Humano', 'Elfo', 'Enano', 'Orco', 'Mediano'];

  String? _razaSeleccionada;

  @override
  Widget build(BuildContext context) {
    //Wrap coloca las tarjetas en fila y salta de línea si no caben.
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _razas.map((raza) {
        return TarjetaRaza(
          nombre: raza,
          seleccionada: raza == _razaSeleccionada,
          onTap: () {
            setState(() {
              _razaSeleccionada = raza;
            });
            widget.onChanged?.call(raza);
          },
        );
      }).toList(),
    );
  }
}

//Tarjeta individual de raza.
//Inactiva: fondo superficie y borde transparente.
//Seleccionada: borde dorado, sombra exterior e icono de check.
class TarjetaRaza extends StatelessWidget {
  final String nombre;
  final bool seleccionada;
  final VoidCallback onTap;

  const TarjetaRaza({
    super.key,
    required this.nombre,
    required this.seleccionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: PaletaColores.superficie,
          borderRadius: BorderRadius.circular(12),
          //El borde siempre mide 1.5 (transparente si no está seleccionada)
          //para que la tarjeta no cambie de tamaño al seleccionarla.
          border: Border.all(
            color: seleccionada
                ? PaletaColores.acentoPrimario
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: seleccionada
              ? [
                  BoxShadow(
                    color: PaletaColores.acentoPrimario.withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              nombre,
              style: AppTipografia.encabezado(
                color: seleccionada
                    ? PaletaColores.acentoPrimario
                    : PaletaColores.textoPrincipal,
                fontSize: 16,
              ),
            ),
            if (seleccionada) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle,
                color: PaletaColores.acentoPrimario,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}