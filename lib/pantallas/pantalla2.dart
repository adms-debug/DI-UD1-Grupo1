import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:creador_personaje_rpg/PaletaColores.dart';
import 'package:creador_personaje_rpg/AppTipografia.dart';
import 'package:creador_personaje_rpg/Buttons.dart';

// ============================================================
// MODELO DE DATOS
// ============================================================

// Nombres legibles de los seis atributos que aparecen en los JSON.
const Map<String, String> _etiquetaAtributo = {
  'fuerza': 'Fuerza',
  'destreza': 'Destreza',
  'constitucion': 'Constitución',
  'inteligencia': 'Inteligencia',
  'sabiduria': 'Sabiduría',
  'carisma': 'Carisma',
};

// Una clase del juego tal y como viene en clases.json.
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

  // Convierte el Map que devuelve jsonDecode en un objeto ClaseRpg.
  factory ClaseRpg.fromJson(Map<String, dynamic> json) {
    final bonos = (json['bonificadores'] as Map<String, dynamic>?) ?? {};
    return ClaseRpg(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      bonificadores: bonos.map((k, v) => MapEntry(k, (v as num).toInt())),
    );
  }

  // Solo los bonificadores distintos de 0 (los que merece la pena mostrar).
  Map<String, int> get bonosActivos =>
      Map.fromEntries(bonificadores.entries.where((e) => e.value != 0));
}

// Definición visual de un atributo físico.
class _DefAtributo {
  final String clave;
  final String nombre;
  final String descripcion;
  final IconData icono;

  const _DefAtributo(this.clave, this.nombre, this.descripcion, this.icono);
}

const List<_DefAtributo> _atributosFisicos = [
  _DefAtributo(
    'fuerza',
    'Fuerza',
    'Potencia y capacidad de carga',
    Icons.fitness_center,
  ),
  _DefAtributo(
    'destreza',
    'Destreza',
    'Agilidad, reflejos y precisión',
    Icons.bolt,
  ),
  _DefAtributo(
    'constitucion',
    'Constitución',
    'Resistencia y vigor físico',
    Icons.favorite,
  ),
];

// Icono temático para cada clase (el JSON no incluye imágenes).
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

// Recibe los datos de la pantalla anterior (datosPrevios) y, al pulsar
// "Siguiente", entrega esos mismos datos + clase + atributos físicos
// mediante el callback onSiguiente.
class Pantalla2 extends StatefulWidget {
  // Datos acumulados de pantallas anteriores (nombre, biografía, raza...).
  // Si ya contiene 'claseId' y 'atributosFisicos' (el usuario volvió
  // atrás), la pantalla restaura esa selección.
  final Map<String, dynamic> datosPrevios;

  // Se llama al pulsar "Siguiente" con todos los datos acumulados.
  final ValueChanged<Map<String, dynamic>>? onSiguiente;

  const Pantalla2({super.key, this.datosPrevios = const {}, this.onSiguiente});

  @override
  State<Pantalla2> createState() => _Pantalla2State();
}

class _Pantalla2State extends State<Pantalla2> {
  // ---- Reglas del reparto ----
  static const int _base = 8; // valor inicial de cada atributo
  static const int _min = 8; // mínimo permitido
  static const int _max = 15; // máximo permitido
  static const int _puntosTotales = 12; // puntos a repartir

  // ---- Estado ----
  List<ClaseRpg> _clases = [];
  bool _cargando = true;
  String? _error;

  String? _claseId; // clase elegida (null = ninguna aún)
  late Map<String, int> _valores; // valor actual de cada atributo
  bool _mostrarReglas = true;

  @override
  void initState() {
    super.initState();

    // Todos los atributos empiezan en el valor base.
    _valores = {for (final a in _atributosFisicos) a.clave: _base};

    // Restaurar selección si el usuario vuelve a esta pantalla.
    _restaurarDatosPrevios();

    _cargarClases();
  }

  void _restaurarDatosPrevios() {
    final previos = widget.datosPrevios;
    final id = previos['claseId'];
    if (id is String) _claseId = id;

    final guardados = previos['atributosFisicos'];
    if (guardados is Map) {
      final restaurados = Map<String, int>.from(_valores);
      for (final a in _atributosFisicos) {
        final v = guardados[a.clave];
        if (v is int) restaurados[a.clave] = v.clamp(_min, _max).toInt();
      }
      // Solo se acepta si respeta el total de puntos.
      final usados =
          restaurados.values.fold<int>(0, (s, v) => s + v) -
          _base * _atributosFisicos.length;
      if (usados <= _puntosTotales) _valores = restaurados;
    }
  }

  // Lee clases.json con rootBundle y lo convierte con jsonDecode.
  Future<void> _cargarClases() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final texto = await rootBundle.loadString('assets/data/clases.json');
      final lista = jsonDecode(texto) as List<dynamic>;
      final clases = lista
          .map((e) => ClaseRpg.fromJson(e as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _clases = clases;
        // Si la clase restaurada ya no existe, se descarta.
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

  // ---- Valores derivados ----
  int get _usados =>
      _valores.values.fold<int>(0, (s, v) => s + v) -
      _base * _atributosFisicos.length;

  int get _libres => _puntosTotales - _usados;

  ClaseRpg? get _claseSeleccionada {
    for (final c in _clases) {
      if (c.id == _claseId) return c;
    }
    return null;
  }

  bool get _puedeContinuar => _claseSeleccionada != null && _libres == 0;

  // ---- Acciones ----

  void _seleccionarClase(ClaseRpg clase) {
    setState(() => _claseId = clase.id);
  }

  // Cambia un atributo respetando mínimo, máximo y puntos libres.
  void _cambiarAtributo(String clave, int nuevo) {
    final actual = _valores[clave]!;
    var objetivo = nuevo.clamp(_min, _max).toInt();

    // No se puede gastar más de lo que queda.
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

  // Datos que viajan a la siguiente pantalla (se conservan los previos).
  Map<String, dynamic> _datosActuales() {
    final clase = _claseSeleccionada;
    return {
      ...widget.datosPrevios,
      'claseId': clase?.id,
      'clase': clase?.nombre,
      'bonificadoresClase': clase?.bonosActivos ?? <String, int>{},
      'atributosFisicos': Map<String, int>.from(_valores),
    };
  }

  void _aviso(String mensaje) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: PaletaColores.superficie,
        content: Text(
          mensaje,
          style: AppTipografia.cuerpo(
            color: PaletaColores.textoPrincipal,
            fontSize: 14,
          ),
        ),
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

    final datos = _datosActuales();
    if (widget.onSiguiente != null) {
      widget.onSiguiente!(datos);
    } else {
      // Modo prueba: la pantalla funciona sola sin navegación conectada.
      debugPrint('Pantalla 2 -> $datos');
      _aviso('Datos de la pantalla 2 guardados.');
    }
  }

  // ============================================================
  // INTERFAZ
  // ============================================================

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
            const Icon(Icons.shield, color: PaletaColores.acentoPrimario),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Clase y atributos',
                overflow: TextOverflow.ellipsis,
                style: AppTipografia.titularSeccion(
                  color: PaletaColores.acentoPrimario,
                  fontSize: 22,
                ),
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
      return const Center(
        child: CircularProgressIndicator(color: PaletaColores.acentoPrimario),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: PaletaColores.alerta,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: AppTipografia.cuerpo(
                  color: PaletaColores.textoPrincipal,
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _cargarClases,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: TextButton.styleFrom(
                  foregroundColor: PaletaColores.acentoPrimario,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ListView: zona con scroll para que nada se desborde en móviles pequeños.
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

  // ---- Indicador "Paso 2 de 4" ----
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
                  color: i < 2
                      ? PaletaColores.acentoPrimario
                      : PaletaColores.superficie,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Paso 2 de 4 · Clase y atributos físicos',
          style: AppTipografia.etiqueta(
            color: PaletaColores.textoSecundario,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ---- Contenedor reutilizable ----
  Widget _panel({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PaletaColores.superficie,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: PaletaColores.acentoPrimario.withValues(alpha: 0.25),
        ),
      ),
      child: child,
    );
  }

  // ---- Sección: clases disponibles ----
  Widget _seccionClases() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clase',
          style: AppTipografia.titularSeccion(
            color: PaletaColores.acentoPrimario,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${_clases.length} caminos disponibles',
          style: AppTipografia.etiqueta(
            color: PaletaColores.textoSecundario,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        // LayoutBuilder para saber el ancho y colocar 2 tarjetas por fila.
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
                    onTap: () => _seleccionarClase(clase),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  // ---- Panel con el detalle de la clase elegida ----
  Widget _panelClaseElegida() {
    final clase = _claseSeleccionada;

    if (clase == null) {
      return _panel(
        child: Row(
          children: [
            const Icon(Icons.touch_app, color: PaletaColores.textoSecundario),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Elige una clase para continuar.',
                style: AppTipografia.cuerpo(
                  color: PaletaColores.textoSecundario,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final bonos = clase.bonosActivos;

    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CLASE ELEGIDA',
            style: AppTipografia.etiqueta(
              color: PaletaColores.acentoPrimario,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(_iconoClase(clase.id), color: PaletaColores.acentoPrimario),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  clase.nombre,
                  style: AppTipografia.encabezado(fontSize: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            clase.descripcion,
            style: AppTipografia.cuerpo(
              color: PaletaColores.textoSecundario,
              fontSize: 14,
            ),
          ),
          if (bonos.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: bonos.entries.map((e) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: PaletaColores.fondo,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: PaletaColores.acentoPrimario),
                  ),
                  child: Text(
                    '+${e.value} ${_etiquetaAtributo[e.key] ?? e.key}',
                    style: AppTipografia.etiqueta(
                      color: PaletaColores.acentoPrimario,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ---- Sección: atributos físicos y puntos ----
  Widget _seccionAtributos() {
    final sinPuntos = _libres == 0;

    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Atributos físicos',
            style: AppTipografia.titularSeccion(
              color: PaletaColores.acentoPrimario,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'REPARTO POR PUNTOS',
            style: AppTipografia.etiqueta(
              color: PaletaColores.textoSecundario,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // Contador de puntos
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$_libres',
                style: AppTipografia.titularSeccion(
                  color: sinPuntos
                      ? PaletaColores.acentoPrimario
                      : PaletaColores.textoPrincipal,
                  fontSize: 40,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Puntos disponibles',
                      style: AppTipografia.encabezado(fontSize: 15),
                    ),
                    Text(
                      '$_usados de $_puntosTotales utilizados',
                      style: AppTipografia.etiqueta(
                        color: PaletaColores.textoSecundario,
                        fontSize: 12,
                      ),
                    ),
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
              color: PaletaColores.acentoPrimario,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            sinPuntos
                ? 'Sin puntos libres. Reduce un atributo para aumentar otro.'
                : 'Te quedan $_libres puntos por repartir.',
            style: AppTipografia.etiqueta(
              color: sinPuntos
                  ? PaletaColores.acentoPrimario
                  : PaletaColores.textoSecundario,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // Una fila por atributo
          for (final def in _atributosFisicos) ...[
            _filaAtributo(def),
            const SizedBox(height: 14),
          ],

          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _usados == 0 ? null : _reiniciarReparto,
              icon: const Icon(Icons.restart_alt, size: 18),
              label: Text(
                'Reiniciar reparto',
                style: AppTipografia.etiqueta(
                  color: _usados == 0
                      ? PaletaColores.textoSecundario
                      : PaletaColores.acentoPrimario,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: PaletaColores.acentoPrimario,
                disabledForegroundColor: PaletaColores.textoSecundario,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filaAtributo(_DefAtributo def) {
    final valor = _valores[def.clave]!;
    final invertidos = valor - _base;
    final enMinimo = valor <= _min;
    final enMaximo = valor >= _max;
    // Para subir hace falta no estar en el máximo Y tener puntos libres.
    final puedeSubir = !enMaximo && _libres > 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PaletaColores.fondo,
        borderRadius: BorderRadius.circular(12),
      ),
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
                    Text(
                      def.nombre,
                      style: AppTipografia.encabezado(fontSize: 16),
                    ),
                    Text(
                      def.descripcion,
                      style: AppTipografia.etiqueta(
                        color: PaletaColores.textoSecundario,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _botonCantidad(
                icono: Icons.remove,
                onPressed: enMinimo
                    ? null
                    : () => _cambiarAtributo(def.clave, valor - 1),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  '$valor',
                  textAlign: TextAlign.center,
                  style: AppTipografia.titularSeccion(
                    color: PaletaColores.textoPrincipal,
                    fontSize: 22,
                  ),
                ),
              ),
              _botonCantidad(
                icono: Icons.add,
                onPressed: puedeSubir
                    ? () => _cambiarAtributo(def.clave, valor + 1)
                    : null,
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: PaletaColores.alerta,
              inactiveTrackColor: PaletaColores.superficie,
              thumbColor: PaletaColores.acentoPrimario,
              overlayColor: PaletaColores.acentoPrimario.withValues(alpha: 0.2),
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
              valueIndicatorColor: PaletaColores.acentoPrimario,
              valueIndicatorTextStyle: AppTipografia.etiqueta(
                color: PaletaColores.fondo,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Slider(
              value: valor.toDouble(),
              min: _min.toDouble(),
              max: _max.toDouble(),
              divisions: _max - _min,
              label: '$valor',
              onChanged: (v) => _cambiarAtributo(def.clave, v.round()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$invertidos ${invertidos == 1 ? 'punto invertido' : 'puntos invertidos'}',
                style: AppTipografia.etiqueta(
                  color: PaletaColores.acentoPrimario,
                  fontSize: 12,
                ),
              ),
              if (enMaximo)
                Text(
                  'Máximo alcanzado',
                  style: AppTipografia.etiqueta(
                    color: PaletaColores.alerta,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else if (enMinimo)
                Text(
                  'Mínimo',
                  style: AppTipografia.etiqueta(
                    color: PaletaColores.textoSecundario,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Botón + / - de cada atributo.
  Widget _botonCantidad({required IconData icono, VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icono, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: PaletaColores.superficie,
        foregroundColor: PaletaColores.acentoPrimario,
        disabledForegroundColor: PaletaColores.textoSecundario,
        fixedSize: const Size(36, 36),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: PaletaColores.acentoPrimario.withValues(
              alpha: onPressed == null ? 0.15 : 0.6,
            ),
          ),
        ),
      ),
    );
  }

  // ---- Panel de reglas (se muestra/oculta con un Switch) ----
  Widget _panelReglas() {
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Reglas de reparto',
                  style: AppTipografia.encabezado(
                    color: PaletaColores.acentoPrimario,
                    fontSize: 15,
                  ),
                ),
              ),
              Switch(
                value: _mostrarReglas,
                onChanged: (v) => setState(() => _mostrarReglas = v),
                thumbColor: WidgetStateProperty.resolveWith((states) {
                  return states.contains(WidgetState.selected)
                      ? PaletaColores.fondo
                      : PaletaColores.textoSecundario;
                }),
                trackColor: WidgetStateProperty.resolveWith((states) {
                  return states.contains(WidgetState.selected)
                      ? PaletaColores.acentoPrimario
                      : PaletaColores.fondo;
                }),
              ),
            ],
          ),
          if (_mostrarReglas) ...[
            const SizedBox(height: 8),
            Text(
              'Base de $_base en cada atributo · Mínimo $_min, máximo $_max.\n'
              'Cada aumento de +1 cuesta 1 punto; al restarlo, se devuelve.\n'
              'Reparte los $_puntosTotales puntos antes de continuar.\n'
              'La clase elegida no altera el coste ni los límites.',
              style: AppTipografia.etiqueta(
                color: PaletaColores.textoSecundario,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---- Resumen + botones de navegación ----
  Widget _zonaBotones() {
    final clase = _claseSeleccionada;
    final resumen = [
      clase?.nombre ?? 'Sin clase',
      for (final a in _atributosFisicos) '${a.nombre} ${_valores[a.clave]}',
    ].join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          resumen,
          style: AppTipografia.etiqueta(
            color: PaletaColores.textoPrincipal,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 12),
        // BotonSiguiente no admite estar desactivado, así que se atenúa y
        // _siguiente() explica con un aviso qué falta por completar.
        Opacity(
          opacity: _puedeContinuar ? 1 : 0.5,
          child: BotonSiguiente(onPressed: _siguiente),
        ),
        const SizedBox(height: 10),
        // Al volver atrás se devuelven los datos actuales a la pantalla
        // anterior (si esta espera el resultado del push).
        BotonAtras(
          onPressed: () => Navigator.maybePop(context, _datosActuales()),
        ),
      ],
    );
  }
}

// ============================================================
// TARJETA DE CLASE
// ============================================================

// Inactiva: fondo superficie y borde transparente.
// Seleccionada: borde dorado, sombra e icono de check (mismo criterio
// visual que TarjetaRaza de la pantalla 1).
class _TarjetaClase extends StatelessWidget {
  final ClaseRpg clase;
  final bool seleccionada;
  final VoidCallback onTap;

  const _TarjetaClase({
    required this.clase,
    required this.seleccionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: PaletaColores.superficie,
          borderRadius: BorderRadius.circular(12),
          // Borde siempre de 1.5 para que la tarjeta no cambie de tamaño.
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
        // Stack: el check se superpone en la esquina superior derecha.
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _iconoClase(clase.id),
                  size: 28,
                  color: seleccionada
                      ? PaletaColores.acentoPrimario
                      : PaletaColores.textoSecundario,
                ),
                const SizedBox(height: 8),
                Text(
                  clase.nombre,
                  style: AppTipografia.encabezado(
                    color: seleccionada
                        ? PaletaColores.acentoPrimario
                        : PaletaColores.textoPrincipal,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  clase.descripcion,
                  style: AppTipografia.etiqueta(
                    color: PaletaColores.textoSecundario,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (seleccionada)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.check_circle,
                  color: PaletaColores.acentoPrimario,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
