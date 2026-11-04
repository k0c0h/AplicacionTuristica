import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/turismo_viewmodel.dart';
import '../widgets/lugar_tarjeta.dart';

class LugaresPantalla extends StatelessWidget {
  const LugaresPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TurismoViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Lugares turísticos')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Toca dos veces una tarjeta para agregar o quitar favoritos.',
            ),
          ),
          Expanded(
            child: viewModel.lugares.isEmpty
                ? const Center(child: Text('No hay lugares disponibles.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: viewModel.lugares.length,
                    itemBuilder: (context, indice) {
                      return LugarTarjeta(lugar: viewModel.lugares[indice]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
