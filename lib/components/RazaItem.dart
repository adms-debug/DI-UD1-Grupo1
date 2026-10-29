import 'package:creador_personaje_rpg/paletas/AppTipografia.dart';
import 'package:flutter/material.dart';
import 'package:creador_personaje_rpg/paletas/PaletaColores.dart';

class RazaItem extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final bool seleccionada;
  final VoidCallback? onTap;

  const RazaItem({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    this.seleccionada = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: PaletaColores.superficie,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: seleccionada
                ? PaletaColores.bordePrimario
                : PaletaColores.textoPrincipal,
            width: seleccionada ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icono de la raza
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: PaletaColores.superficie,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icono, color: PaletaColores.bordePrimario, size: 24),
            ),
            const SizedBox(width: 15),

            // Título y descripción
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: AppTipografia.encabezado()),
                  if (subtitulo.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitulo,
                      style: const TextStyle(
                        color: PaletaColores.textoSecundario,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Botón derecho (Check circular si está seleccionada, o botón ELEGIR si no)
            if (seleccionada)
              Container(
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
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: PaletaColores.superficie,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white),
                ),
                child: Text('ELEGIR', style: AppTipografia.etiqueta()),
              ),
          ],
        ),
      ),
    );
  }
}
