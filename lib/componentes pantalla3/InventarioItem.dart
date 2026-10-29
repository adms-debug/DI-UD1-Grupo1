import 'package:creador_personaje_rpg/paletas/AppTipografia.dart';
import 'package:flutter/material.dart';
import 'package:creador_personaje_rpg/paletas/PaletaColores.dart';

class InventarioItem extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final bool equipado; // Para saber si muestra el check o el botón "EQUIPAR"
  final VoidCallback? onTap; //Función opcional al pulsar el objeto
  final VoidCallback? onEquip; //Acción al pulsar el botón equipar

  const InventarioItem({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    this.equipado = false,
    this.onTap,
    this.onEquip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, //ejecuta la función al pulsar el objeto
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: PaletaColores.superficie,
          borderRadius: BorderRadius.circular(16),
          // Si está equipado, el borde es dorado; si no, es sutil
          border: Border.all(
            color: equipado
                ? PaletaColores.bordePrimario
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
              child: Icon(icono, color: PaletaColores.bordePrimario, size: 24),
            ),
            const SizedBox(width: 15),

            // Títulos y descripción del objeto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: AppTipografia.encabezado()),
                  const SizedBox(height: 3),
                  Text(subtitulo, style: AppTipografia.etiqueta()),
                ],
              ),
            ),

            // Botón derecho (Check circular si está equipado, o botón EQUIPAR si no)
            if (equipado)
              GestureDetector(
                onTap: onEquip,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: PaletaColores.bordePrimario,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: PaletaColores.superficie,
                    size: 18,
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: onEquip, //Al pulsar aqui se equipa
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: PaletaColores.superficie,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Text('EQUIPAR', style: AppTipografia.etiqueta()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
