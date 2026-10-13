import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Estilos tipográficos de la aplicación basados en Google Fonts
/// para la temática de fantasía RPG.
class AppTipografia {
  // Evita que se pueda crear un objeto de esta clase.
  AppTipografia._();

  /// 1. Titulares y Nombres de Personajes (UnifrakturMaguntia)
  /// Uso: Nombres legendarios, títulos principales de pantalla.
  static TextStyle titularMagno({
    Color color = const Color(0xFFE5A93C), // Dorado
    double fontSize = 32,
  }) {
    return GoogleFonts.unifrakturMaguntia(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  /// Títulos de sección importantes (Cinzel - Bold)
  /// Uso: Clases, razas, subtítulos principales.
  static TextStyle titularSeccion({
    Color color = const Color(0xFFE5A93C), // Dorado o Blanco
    double fontSize = 24,
  }) {
    return GoogleFonts.cinzel(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  /// Encabezados medianos (Cinzel - Bold)
  static TextStyle encabezado({
    Color color = Colors.white,
    double fontSize = 18,
  }) {
    return GoogleFonts.cinzel(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  /// 2. Subtítulos y Destacados (Cinzel Decorative)
  /// Uso: Biografías destacadas, nombres de objetos singulares.
  static TextStyle subtituloDecorativo({
    Color color = Colors.white,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return GoogleFonts.cinzelDecorative(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// 3. Cuerpo de Texto y Formularios (Roboto)
  /// Uso: Biografía, descripciones generales de equipamiento, párrafos.
  static TextStyle cuerpo({
    Color color = const Color(0xFFF5F5F5), // Blanco roto
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// 4. Etiquetas, Sliders y Elementos Secundarios (Lato)
  /// Uso: Niveles, descripciones grises, etiquetas de formularios y checkboxes.
  static TextStyle etiqueta({
    Color color = const Color(0xFF757575), // Gris
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GoogleFonts.lato(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
