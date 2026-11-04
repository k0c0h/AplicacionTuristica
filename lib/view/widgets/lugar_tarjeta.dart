import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/lugar_turistico_model.dart';
import '../../viewmodels/turismo_viewmodel.dart';

/*
class LugarTuristico {
  final int id;
  final String nombre;
  final String ubicacion;
  final String descripcion;
  final List<String> imagenes;
}*/

class LugarTarjeta extends StatelessWidget {
  const LugarTarjeta({super.key, required this.lugar});

  final LugarTuristico lugar;

  @override
  Widget build(BuildContext context) {
    final esFavorito = context.watch<TurismoViewModel>().favoritos.contains(
      lugar.id,
    );

    return GestureDetector(
      onDoubleTap: () {
        context.read<TurismoViewModel>().alternarFavorito(lugar.id);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (lugar.imagenes.isNotEmpty)
              Image.network(
                lugar.imagenes.first,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 160,
                    child: Icon(Icons.landscape, size: 64),
                  );
                },
              ),
            ListTile(
              title: Text(lugar.nombre),
              subtitle: Text(lugar.ubicacion),
              trailing: Icon(
                esFavorito ? Icons.favorite : Icons.favorite_border,
                color: esFavorito ? Colors.red : Colors.grey,
                semanticLabel: esFavorito ? 'Favorito' : 'Sin favorito',
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<TurismoViewModel>().seleccionarLugar(lugar);
                Navigator.pushNamed(context, '/detalle', arguments: lugar);
              },
              child: const Text('Ver detalle'),
            ),
          ],
        ),
      ),
    );
  }
}
