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
      appBar: AppBar(
        title:  Text(
          'Explora Ecuador',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor:  Color(0xFFE0F2FE),
        foregroundColor:  Color(0xFF075985),
      ),
      body: SafeArea(
        child: Container(
          decoration:  BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE0F2FE), Color(0xFFF8FAFC)],
              stops: [0, 0.3],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:  EdgeInsets.fromLTRB(16, 16, 16, 18),
                padding:  EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient:  LinearGradient(
                    colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow:  [
                    BoxShadow(
                      color: Color(0x330369A1),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding:  EdgeInsets.all(12),
                      decoration:  BoxDecoration(
                        color: Color(0x33FFFFFF),
                        shape: BoxShape.circle,
                      ),
                      child:  Icon(
                        Icons.explore_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                     SizedBox(width: 14),
                     Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Destinos turísticos',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Vive una nueva aventura en Ecuador',
                            style: TextStyle(
                              color: Color(0xD9FFFFFF),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: Row(
                  children: [
                     Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFFF97316),
                      size: 20,
                    ),
                     SizedBox(width: 7),
                    Text(
                      '${viewModel.lugares.length} experiencias para descubrir',
                      style:  TextStyle(
                        color: Color(0xFF334155),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                     Spacer(),
                     Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFFEF4444),
                      size: 18,
                    ),
                     SizedBox(width: 4),
                    Text(
                      '${viewModel.favoritos.length}',
                      style:  TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: viewModel.lugares.isEmpty
                    ?  Center(child: Text('No hay lugares disponibles.'))
                    : ListView.builder(
                        padding:  EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: viewModel.lugares.length,
                        itemBuilder: (context, indice) {
                          return LugarTarjeta(
                            lugar: viewModel.lugares[indice],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
