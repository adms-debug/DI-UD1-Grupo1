import 'package:creador_personaje_rpg/components/ObjetoModelo.dart';

// Datos del personaje, compartidos entre todas las pantallas
class Personaje {
  // Pantalla 1: Identidad y Raza
  static String nombre = '';
  static String biografia = '';
  static Map<String, dynamic>? raza;
  static String razaId = '';
  static String razaNombre = '';
  static String razaDescripcion = '';
  static Map<String, int> bonificadoresRaza = {};

  // Pantalla 2: Clase y Atributos físicos
  static String claseId = '';
  static String claseNombre = '';
  static String claseDescripcion = '';
  static Map<String, int> bonificadoresClase = {};
  static Map<String, int> atributosFisicos = {
    'fuerza': 8,
    'destreza': 8,
    'constitucion': 8,
  };

  // Pantalla 3: Atributos finales (con bonus) y Equipamiento
  static Map<String, int> atributos = {
    'fuerza': 10,
    'destreza': 10,
    'constitucion': 10,
    'inteligencia': 10,
    'sabiduria': 10,
    'carisma': 10,
  };
  static List<ObjetoModelo> equipados = []; // objetos equipados

  // Resetea todos los campos para una nueva creación
  static void reiniciar() {
    nombre = '';
    biografia = '';
    raza = null;
    razaId = '';
    razaNombre = '';
    razaDescripcion = '';
    bonificadoresRaza = {};

    claseId = '';
    claseNombre = '';
    claseDescripcion = '';
    bonificadoresClase = {};
    atributosFisicos = {
      'fuerza': 8,
      'destreza': 8,
      'constitucion': 8,
    };

    atributos = {
      'fuerza': 10,
      'destreza': 10,
      'constitucion': 10,
      'inteligencia': 10,
      'sabiduria': 10,
      'carisma': 10,
    };
    equipados = [];
  }
}
