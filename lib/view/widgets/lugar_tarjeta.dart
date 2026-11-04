import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/lugar_turistico_model.dart';
import '../../viewmodels/turismo_viewmodel.dart';

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
        elevation: 3,
        shadowColor:  Color(0x260F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        margin:  EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 190,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (lugar.imagenes.isNotEmpty)
                    Image.network(
                      lugar.imagenes.first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color:  Color(0xFFE2E8F0),
                          child:  Icon(
                            Icons.landscape_rounded,
                            size: 64,
                            color: Color(0xFF64748B),
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      color:  Color(0xFFE2E8F0),
                      child:  Icon(
                        Icons.landscape_rounded,
                        size: 64,
                        color: Color(0xFF64748B),
                      ),
                    ),
                   DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x12000000), Color(0xB3000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Container(
                      padding:  EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:  Color(0xD9000000),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:  Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.place_rounded,
                            color: Color(0xFFFBBF24),
                            size: 15,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Ecuador',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding:  EdgeInsets.all(9),
                      decoration:  BoxDecoration(
                        color: Color(0xE6FFFFFF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        esFavorito ? Icons.favorite : Icons.favorite_border,
                        color: esFavorito
                            ?  Color(0xFFEF4444)
                            :  Color(0xFF475569),
                        size: 22,
                        semanticLabel:
                            esFavorito ? 'Favorito' : 'Sin favorito',
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 16,
                    child: Text(
                      lugar.nombre,
                      style:  TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            color: Color(0x99000000),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.fromLTRB(18, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                       Icon(
                        Icons.location_on_rounded,
                        size: 18,
                        color: Color(0xFFF97316),
                      ),
                       SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          lugar.ubicacion,
                          style:  TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding:  EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color:  Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.photo_library_rounded,
                              size: 15,
                              color: Color(0xFFF97316),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Galería disponible',
                              style: TextStyle(
                                color: Color(0xFFC2410C),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: 9),
                  Text(
                    lugar.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:  TextStyle(
                      height: 1.35,
                      color: Color(0xFF475569),
                      fontSize: 14,
                    ),
                  ),
                   SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () {
                        context.read<TurismoViewModel>().seleccionarLugar(
                          lugar,
                        );
                        Navigator.pushNamed(
                          context,
                          '/detalle',
                          arguments: lugar,
                        );
                      },
                      icon:  Icon(Icons.arrow_forward_rounded, size: 18),
                      label:  Text('Ver detalle'),
                      style: FilledButton.styleFrom(
                        backgroundColor:  Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        padding:  EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 11,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
