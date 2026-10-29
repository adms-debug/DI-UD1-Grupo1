import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:creador_personaje_rpg/paletas/PaletaColores.dart';
import 'package:creador_personaje_rpg/paletas/AppTipografia.dart';
import 'package:creador_personaje_rpg/components/Buttons.dart';
import 'package:creador_personaje_rpg/components/Personaje.dart';
import 'package:creador_personaje_rpg/pantallas/pantalla3.dart';

// ============================================================
// MODELO DE DATOS
// ============================================================

const Map<String, String> _etiquetaAtributo = {
  'fuerza': 'Fuerza',
  'destreza': 'Destreza',
  'constitucion': 'Constitución',
  'inteligencia': 'Inteligencia',
  'sabiduria': 'Sabiduría',
  'carisma': 'Carisma',
};

class ClaseRpg {
  final String id;
  final String nombre;
  final String descripcion;
  final Map<String, int> bonificadores;

  const ClaseRpg({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.bonificadores,
  });

  factory ClaseRpg.fromJson(Map<String, dynamic> json) {
    final bonos = (json['bonificadores'] as Map<String, dynamic>?) ?? {};
    return ClaseRpg(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      bonificadores: bonos.map((k, v) => MapEntry(k, (v as num).toInt())),
    );
  }

  Map<String, int> get bonosActivos =>
      Map.fromEntries(bonificadores.entries.where((e) => e.value != 0));
}

class _DefAtributo {
  final String clave;
  final String nombre;
  final String descripcion;
  final IconData icono;

  const _DefAtributo(this.clave, this.nombre, this.descripcion, this.icono);
}

const List<_DefAtributo> _atributosFisicos = [
  _DefAtributo('fuerza', 'Fuerza', 'Potencia y capacidad de carga', Icons.fitness_center),
  _DefAtributo('destreza', 'Destreza', 'Agilidad, reflejos y precisión', Icons.bolt),
  _DefAtributo('constitucion', 'Constitución', 'Resistencia y vigor físico', Icons.favorite),
];

IconData _iconoClase(String id) {
  switch (id) {
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

// ============================================================
// PANTALLA 2: CLASE Y ATRIBUTOS FÍSICOS
// ============================================================

class Pantalla2 extends StatefulWidget {
  final Map<String, dynamic> datosPrevios;

  const Pantalla2({super.key, this.datosPrevios = const {}});

  @override
  State<Pantalla2> createState() => _Pantalla2State();
}

class _Pantalla2State extends State<Pantalla2> {
  static const int _base = 8;
  static const int _min = 8;
  static const int _max = 15;
  static const int _puntosTotales = 12;

  List<ClaseRpg> _clases = [];
  bool _cargando = true;
  String? _error;

  String? _claseId;
  late Map<String, int> _valores;
  bool _mostrarReglas = true;

  @override
  void initState() {
    super.initState();
    _valores = {for (final a in _atributosFisicos) a.clave: _base};
    _restaurarDatosPrevios();
    _cargarClases();
  }

  void _restaurarDatosPrevios() {
    if (Personaje.claseId.isNotEmpty) {
      _claseId = Personaje.claseId;
    }
    if (Personaje.atributosFisicos.isNotEmpty) {
      final restaurados = Map<String, int>.from(_valores);
      for (final a in _atributosFisicos) {
        if (Personaje.atributosFisicos.containsKey(a.clave)) {
          restaurados[a.clave] = Personaje.atributosFisicos[a.clave]!.clamp(_min, _max);
        }
      }
      final usados = restaurados.values.fold<int>(0, (s, v) => s + v) - (_base * _atributosFisicos.length);
      if (usados <= _puntosTotales) _valores = restaurados;
    }
  }

  Future<void> _cargarClases() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final texto = await rootBundle.loadString('assets/data/clases.json');
      final lista = jsonDecode(texto) as List<dynamic>;
      final clases = lista.map((e) => ClaseRpg.fromJson(e as Map<String, dynamic>)).toList();

      if (!mounted) return;
      setState(() {
        _clases = clases;
        if (_claseId != null && !clases.any((c) => c.id == _claseId)) {
          _claseId = null;
        }
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudieron cargar las clases.';
        _cargando = false;
      });
    }
  }

  int get _usados => _valores.values.fold<int>(0, (s, v) => s + v) - (_base * _atributosFisicos.length);
  int get _libres => _puntosTotales - _usados;

  ClaseRpg? get _claseSeleccionada {
    for (final c in _clases) {
      if (c.id == _claseId) return c;
    }
    return null;
  }

  void _cambiarAtributo(String clave, int nuevo) {
    final actual = _valores[clave]!;
    var objetivo = nuevo.clamp(_min, _max).toInt();
    final aumento = objetivo - actual;
    if (aumento > _libres) objetivo = actual + _libres;

    if (objetivo == actual) return;
    setState(() => _valores[clave] = objetivo);
  }

  void _reiniciarReparto() {
    setState(() {
      for (final a in _atributosFisicos) {
        _valores[a.clave] = _base;
      }
    });
  }

  void _aviso(String mensaje) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: PaletaColores.superficie,
        content: Text(mensaje, style: AppTipografia.cuerpo(color: PaletaColores.textoPrincipal, fontSize: 14)),
      ),
    );
  }

  void _siguiente() {
    if (_claseSeleccionada == null) {
      _aviso('Elige una clase para continuar.');
      return;
    }
    if (_libres > 0) {
      _aviso('Reparte los $_libres puntos que te quedan antes de continuar.');
      return;
    }

    Personaje.claseId = _claseSeleccionada!.id;
    Personaje.claseNombre = _claseSeleccionada!.nombre;
    Personaje.claseDescripcion = _claseSeleccionada!.descripcion;
    Personaje.bonificadoresClase = _claseSeleccionada!.bonosActivos;
    Personaje.atributosFisicos = Map<String, int>.from(_valores);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Pantalla3(datosPrevios: widget.datosPrevios),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaletaColores.fondo,
      appBar: AppBar(
        backgroundColor: PaletaColores.superficie,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shield, color: PaletaColores.bordePrimario),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Clase y atributos',
                overflow: TextOverflow.ellipsis,
                style: AppTipografia.titularSeccion(color: PaletaColores.bordePrimario, fontSize: 22),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(child: _cuerpo()),
    );
  }

  Widget _cuerpo() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator(color: PaletaColores.bordePrimario));
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: PaletaColores.alerta, size: 40),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center, style: AppTipografia.cuerpo(color: PaletaColores.textoPrincipal)),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _cargarClases,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: TextButton.styleFrom(foregroundColor: PaletaColores.bordePrimario),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _indicadorPaso(),
        const SizedBox(height: 20),
        _seccionClases(),
        const SizedBox(height: 16),
        _panelClaseElegida(),
        const SizedBox(height: 24),
        _seccionAtributos(),
        const SizedBox(height: 16),
        _panelReglas(),
        const SizedBox(height: 24),
        _zonaBotones(),
      ],
    );
  }

  Widget _indicadorPaso() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                decoration: BoxDecoration(
                  color: i < 2 ? PaletaColores.bordePrimario : PaletaColores.superficie,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text('Paso 2 de 4 · Clase y atributos físicos', style: AppTipografia.etiqueta(color: PaletaColores.textoSecundario, fontSize: 12)),
      ],
    );
  }

  Widget _panel({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PaletaColores.superficie,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PaletaColores.bordePrimario.withOpacity(0.25)),
      ),
      child: child,
    );
  }

  Widget _seccionClases() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Clase', style: AppTipografia.titularSeccion(color: PaletaColores.bordePrimario, fontSize: 20)),
        const SizedBox(height: 4),
        Text('${_clases.length} caminos disponibles', style: AppTipografia.etiqueta(color: PaletaColores.textoSecundario, fontSize: 12)),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            const separacion = 10.0;
            final ancho = (constraints.maxWidth - separacion) / 2;
            return Wrap(
              spacing: separacion,
              runSpacing: separacion,
              children: _clases.map((clase) {
                return SizedBox(
                  width: ancho,
                  child: _TarjetaClase(
                    clase: clase,
                    seleccionada: clase.id == _claseId,
                    onTap: () => setState(() => _claseId = clase.id),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _panelClaseElegida() {
    final clase = _claseSeleccionada;
    if (clase == null) {
      return _panel(
        child: Row(
          children: [
            const Icon(Icons.touch_app, color: PaletaColores.textoSecundario),
            const SizedBox(width: 12),
            Expanded(child: Text('Elige una clase para continuar.', style: AppTipografia.cuerpo(color: PaletaColores.textoSecundario, fontSize: 14))),
          ],
        ),
      );
    }

    final bonos = clase.bonosActivos;
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CLASE ELEGIDA', style: AppTipografia.etiqueta(color: PaletaColores.bordePrimario, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(_iconoClase(clase.id), color: PaletaColores.bordePrimario),
              const SizedBox(width: 10),
              Flexible(child: Text(clase.nombre, style: AppTipografia.encabezado(fontSize: 20))),
            ],
          ),
          const SizedBox(height: 6),
          Text(clase.descripcion, style: AppTipografia.cuerpo(color: PaletaColores.textoSecundario, fontSize: 14)),
          if (bonos.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: bonos.entries.map((e) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: PaletaColores.fondo,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: PaletaColores.bordePrimario),
                  ),
                  child: Text('+${e.value} ${_etiquetaAtributo[e.key] ?? e.key}', style: AppTipografia.etiqueta(color: PaletaColores.bordePrimario, fontSize: 12, fontWeight: FontWeight.bold)),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _seccionAtributos() {
    final sinPuntos = _libres == 0;
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Atributos físicos', style: AppTipografia.titularSeccion(color: PaletaColores.bordePrimario, fontSize: 20)),
          const SizedBox(height: 4),
          Text('REPARTO POR PUNTOS', style: AppTipografia.etiqueta(color: PaletaColores.textoSecundario, fontSize: 12)),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('$_libres', style: AppTipografia.titularSeccion(color: sinPuntos ? PaletaColores.bordePrimario : PaletaColores.textoPrincipal, fontSize: 40)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Puntos disponibles', style: AppTipografia.encabezado(fontSize: 15)),
                    Text('$_usados de $_puntosTotales utilizados', style: AppTipografia.etiqueta(color: PaletaColores.textoSecundario, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _usados / _puntosTotales,
              minHeight: 8,
              backgroundColor: PaletaColores.fondo,
              color: PaletaColores.bordePrimario,
            ),
          ),
          const SizedBox(height: 16),
          for (final def in _atributosFisicos) ...[
            _filaAtributo(def),
            const SizedBox(height: 14),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _usados == 0 ? null : _reiniciarReparto,
              icon: const Icon(Icons.restart_alt, size: 18),
              label: Text('Reiniciar reparto', style: AppTipografia.etiqueta(color: _usados == 0 ? PaletaColores.textoSecundario : PaletaColores.bordePrimario, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filaAtributo(_DefAtributo def) {
    final valor = _valores[def.clave]!;
    final enMinimo = valor <= _min;
    final enMaximo = valor >= _max;
    final puedeSubir = !enMaximo && _libres > 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: PaletaColores.fondo, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(def.icono, color: PaletaColores.alerta),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(def.nombre, style: AppTipografia.encabezado(fontSize: 16)),
                    Text(def.descripcion, style: AppTipografia.etiqueta(color: PaletaColores.textoSecundario, fontSize: 12)),
                  ],
                ),
              ),
              _botonCantidad(icono: Icons.remove, onPressed: enMinimo ? null : () => _cambiarAtributo(def.clave, valor - 1)),
              SizedBox(width: 36, child: Text('$valor', textAlign: TextAlign.center, style: AppTipografia.titularSeccion(color: PaletaColores.textoPrincipal, fontSize: 22))),
              _botonCantidad(icono: Icons.add, onPressed: puedeSubir ? () => _cambiarAtributo(def.clave, valor + 1) : null),
            ],
          ),
        ],
      ),
    );
  }

  Widget _botonCantidad({required IconData icono, VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icono, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: PaletaColores.superficie,
        foregroundColor: PaletaColores.bordePrimario,
        disabledForegroundColor: PaletaColores.textoSecundario,
        fixedSize: const Size(36, 36),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: PaletaColores.bordePrimario.withOpacity(onPressed == null ? 0.15 : 0.6)),
        ),
      ),
    );
  }

  Widget _panelReglas() {
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Reglas de reparto', style: AppTipografia.encabezado(color: PaletaColores.bordePrimario, fontSize: 15))),
              Switch(
                value: _mostrarReglas,
                onChanged: (v) => setState(() => _mostrarReglas = v),
              ),
            ],
          ),
          if (_mostrarReglas) ...[
            const SizedBox(height: 8),
            Text('Base de $_base en cada atributo · Mínimo $_min, máximo $_max.\nReparte los $_puntosTotales puntos.', style: AppTipografia.etiqueta(color: PaletaColores.textoSecundario, fontSize: 13)),
          ],
        ],
      ),
    );
  }

  Widget _zonaBotones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BotonSiguiente(onPressed: _siguiente),
        const SizedBox(height: 10),
        BotonAtras(onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}

class _TarjetaClase extends StatelessWidget {
  final ClaseRpg clase;
  final bool seleccionada;
  final VoidCallback onTap;

  const _TarjetaClase({required this.clase, required this.seleccionada, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: PaletaColores.superficie,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: seleccionada ? PaletaColores.bordePrimario : Colors.transparent, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_iconoClase(clase.id), size: 28, color: seleccionada ? PaletaColores.bordePrimario : PaletaColores.textoSecundario),
            const SizedBox(height: 8),
            Text(clase.nombre, style: AppTipografia.encabezado(color: seleccionada ? PaletaColores.bordePrimario : PaletaColores.textoPrincipal, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}