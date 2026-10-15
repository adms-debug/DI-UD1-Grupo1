import 'package:creador_personaje_rpg/AppTipografia.dart';
import 'package:flutter/material.dart';
import 'package:creador_personaje_rpg/PaletaColores.dart';

class InventarioItem extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final bool equipado; // Para saber si muestra el check o el botón "EQUIPAR"

  const InventarioItem({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    this.equipado = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PaletaColores.superficie,
        borderRadius: BorderRadius.circular(16),
        // Si está equipado, el borde es dorado; si no, es sutil
        border: Border.all(
          color: equipado
              ? PaletaColores.acentoPrimario
              : PaletaColores.textoPrincipal,
          width: equipado ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Icono del objeto
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PaletaColores.superficie,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icono, color: PaletaColores.acentoPrimario, size: 24),
          ),
          const SizedBox(width: 15),

          // Títulos y descripción del objeto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: AppTipografia.encabezado()),
                const SizedBox(height: 3),
                Text(subtitulo, style: const TextStyle()),
              ],
            ),
          ),

          // Botón derecho (Check circular si está equipado, o botón EQUIPAR si no)
          if (equipado)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: PaletaColores.acentoPrimario,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: PaletaColores.superficie,
                size: 18,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: PaletaColores.superficie,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white),
              ),
              child: Text('EQUIPAR', style: AppTipografia.etiqueta()),
            ),
        ],
      ),
    );
  }
}
