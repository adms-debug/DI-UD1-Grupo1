import 'package:flutter/material.dart';
import 'PaletaColores.dart';
import 'AppTipografia.dart';
import 'buttons.dart';

//Pantalla simple para crear un personaje RPG.
//Tiene un campo de texto (nombre), un desplegable (raza) y un botón.
class CrearPersonaje extends StatefulWidget {
  const CrearPersonaje({super.key});

  @override
  State<CrearPersonaje> createState() => _CrearPersonajeState();
}

class _CrearPersonajeState extends State<CrearPersonaje> {
  //Controlador: permite leer lo que el usuario escribe en el TextField.
  final TextEditingController _nombreController = TextEditingController();

  //Aquí se guarda la raza que elija el usuario en el desplegable.
  String? _raza;

  //Libera el controlador cuando la pantalla se cierra.
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
        title: Text(
          'Crear personaje',
          style: AppTipografia.titularMagno(fontSize: 28),
        ),
        backgroundColor: PaletaColores.superficie,
        foregroundColor: PaletaColores.acentoPrimario,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: PaletaColores.acentoPrimario),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SelectorRaza(
              onChanged: (raza) => _raza = raza,
            ),
            const SizedBox(height: 16),
            BotonCrearPersonaje(onPressed: _crear),
          ],
        ),
      ),
    );
  }
}

//Desplegable para elegir la raza del personaje.
//Es StatefulWidget porque necesita recordar la raza seleccionada.
class SelectorRaza extends StatefulWidget {
  //Función opcional para avisar a la pantalla padre de la raza elegida.
  final ValueChanged<String>? onChanged;

  const SelectorRaza({super.key, this.onChanged});

  @override
  State<SelectorRaza> createState() => _SelectorRazaState();
}

class _SelectorRazaState extends State<SelectorRaza> {
  final List<String> _razas = ['Humano', 'Elfo', 'Enano', 'Orco', 'Mediano'];

  //Raza elegida. Empieza en null: todavía no se ha seleccionado ninguna.
  String? _razaSeleccionada;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: _razaSeleccionada,
      dropdownColor: PaletaColores.superficie,
      style: AppTipografia.cuerpo(color: PaletaColores.textoPrincipal),
      decoration: InputDecoration(
        labelText: 'Raza',
        labelStyle:
            AppTipografia.etiqueta(color: PaletaColores.textoSecundario),
        filled: true,
        fillColor: PaletaColores.superficie,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: PaletaColores.acentoPrimario),
        ),
      ),
      items: _razas
          .map((raza) => DropdownMenuItem<String>(
                value: raza,
                child: Text(raza),
              ))
          .toList(),
      onChanged: (String? nuevaRaza) {
        setState(() {
          _razaSeleccionada = nuevaRaza;
        });
        if (nuevaRaza != null) {
          widget.onChanged?.call(nuevaRaza);
        }
      },
    );
  }
}