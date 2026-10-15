import 'package:creador_personaje_rpg/AppTipografia.dart';
import 'package:flutter/material.dart';
import 'package:creador_personaje_rpg/PaletaColores.dart';

class AtributoItem extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final String valor;
  final double progreso;

  const AtributoItem({
    super.key,
    required this.titulo,
    required this.icono,
    required this.valor,
    required this.progreso,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PaletaColores.superficie,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PaletaColores.textoPrincipal),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icono del atributo
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: PaletaColores.superficie,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icono,
                  color: PaletaColores.acentoSecundario,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // Nombre
              Expanded(child: Text(titulo, style: AppTipografia.encabezado())),

              // Botón Menos
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: PaletaColores.superficie,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.remove,
                  color: PaletaColores.textoSecundario,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              // Valor numérico
              Text(
                valor,
                style: const TextStyle(
                  color: PaletaColores.acentoSecundario,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),

              // Botón Más
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: PaletaColores.superficie,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add,
                  color: PaletaColores.textoSecundario,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Barra de progreso inferior
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progreso,
              backgroundColor: PaletaColores.superficie,
              valueColor: const AlwaysStoppedAnimation<Color>(
                PaletaColores.acentoSecundario,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
