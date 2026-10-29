class ObjetoModelo {
  final String id;
  final String nombre;
  final String tipo;
  final String descripcion;
  final Map<String, int> bonificadores;
  final List<String> clasesPermitidas;

  const ObjetoModelo({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.descripcion,
    required this.bonificadores,
    required this.clasesPermitidas,
  });

  factory ObjetoModelo.fromJson(Map<String, dynamic> json) {
    return ObjetoModelo(
      id: json['id'],
      nombre: json['nombre'],
      tipo: json['tipo'],
      descripcion: json['descripcion'],
      bonificadores: Map<String, int>.from(json['bonificadores']),
      clasesPermitidas: List<String>.from(json['clases_permitidas']),
    );
  }
}
