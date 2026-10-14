import 'package:flutter/material.dart';

/// Paleta de colores de la aplicación.
/// Todos los colores son static const: se usan directamente con
/// PaletaColores.nombre, sin crear ningún objeto.
class PaletaColores {
  // Evita que se pueda crear un objeto de esta clase (solo agrupa constantes).
  PaletaColores._();

  /// Fondo general (Scaffold). Reduce la fatiga visual.
  static const Color fondo = Color(0xFF12131A);

  /// Fondo de contenedores (Container, Card, TextField).
  static const Color superficie = Color(0xFF1E202C);

  /// Acento primario (dorado): botones principales, bordes activos y títulos.
  static const Color acentoPrimario = Color(0xFFE5A93C);

  /// Acento secundario (púrpura): atributos mentales, barras de progreso y elementos mágicos.
  static const Color acentoSecundario = Color(0xFF8A5CF5);

  /// Atributos físicos y alertas (rojo carmesí): fuerza, vida e indicadores de límites.
  static const Color alerta = Color(0xFFD9534F);

  /// Texto principal sobre fondos oscuros.
  static const Color textoPrincipal = Color(0xFFF0F1F5);

  /// Texto secundario: biografías, descripciones y campos no seleccionados.
  static const Color textoSecundario = Color(0xFF8F94A6);
}
