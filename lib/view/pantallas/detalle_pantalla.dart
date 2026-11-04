import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/lugar_turistico_model.dart';
import '../../viewmodels/turismo_viewmodel.dart';

/// Pantalla 3: Detalle del Lugar Turístico y Galería
///
/// Tareas cumplidas según requerimientos:
/// - Recibe los datos del lugar turístico mediante ModalRoute arguments.
/// - Muestra nombre, ubicación, descripción y fotografías.
/// - Implementa el deslizamiento horizontal (Gesto 2) para recorrer las fotografías.
/// - Actualiza la imagen actual a través de TurismoViewModel (Provider).
/// - Muestra visualmente si el lugar se encuentra guardado en favoritos.
/// - Diseño limpio, sencillo y acorde a una aplicación turística moderna.
class DetallePantalla extends StatefulWidget {
   const DetallePantalla({super.key});

  static const String routeName = '/detalle';

  @override
  State<DetallePantalla> createState() => _DetallePantallaState();
}

class _DetallePantallaState extends State<DetallePantalla> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final viewModel = context.watch<TurismoViewModel>();
    final LugarTuristico? lugar = (args is LugarTuristico)
        ? args
        : (viewModel.lugarSeleccionado ??
            (viewModel.lugares.isNotEmpty ? viewModel.lugares.first : null));

    if (lugar == null) {
      return Scaffold(
        appBar: AppBar(title:  Text('Detalle del Lugar')),
        body:  Center(
          child: Text('No se encontraron datos del lugar turístico.'),
        ),
      );
    }

    final bool esFavorito = viewModel.esFavorito(lugar.id);
    final int indiceActual = viewModel.indiceImagenActual;

    return Scaffold(
      backgroundColor:  Color(0xFFF7F9FC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340.0,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: Padding(
              padding:  EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor:  Color(0x73000000),
                child: IconButton(
                  icon:  Icon(Icons.arrow_back, color: Colors.white),
                  tooltip: 'Regresar',
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
            actions: [
              Padding(
                padding:  EdgeInsets.only(right: 12.0),
                child: CircleAvatar(
                  backgroundColor:  Color(0x73000000),
                  child: IconButton(
                    icon: Icon(
                      esFavorito ? Icons.favorite : Icons.favorite_border,
                      color: esFavorito ? Colors.redAccent : Colors.white,
                    ),
                    tooltip: esFavorito
                        ? 'Quitar de favoritos'
                        : 'Guardar en favoritos',
                    onPressed: () {
                      context.read<TurismoViewModel>().alternarFavorito(lugar.id);
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: lugar.imagenes.length,
                    onPageChanged: (indice) {
                      context.read<TurismoViewModel>().cambiarImagen(indice);
                    },
                    itemBuilder: (context, index) {
                      final url = lugar.imagenes[index];
                      return Image.network(
                        url,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: Colors.grey.shade300,
                            child:  Center(
                              child: CircularProgressIndicator(strokeWidth: 2.5),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.blueGrey.shade700,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Icon(
                                  Icons.landscape_rounded,
                                  size: 64,
                                  color: Colors.white70,
                                ),
                                 SizedBox(height: 8),
                                Text(
                                  lugar.nombre,
                                  style:  TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                   Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x4D000000),
                              Colors.transparent,
                              Color(0xA6000000),
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: List.generate(
                            lugar.imagenes.length,
                            (i) => AnimatedContainer(
                              duration:  Duration(milliseconds: 300),
                              margin:  EdgeInsets.symmetric(horizontal: 3),
                              width: indiceActual == i ? 22 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: indiceActual == i
                                    ? Colors.white
                                    :  Color(0x73FFFFFF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding:  EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color:  Color(0x8C000000),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                               Icon(
                                Icons.swipe,
                                size: 14,
                                color: Colors.white70,
                              ),
                               SizedBox(width: 4),
                              Text(
                                '${indiceActual + 1}/${lugar.imagenes.length}',
                                style:  TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:  EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding:  EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: esFavorito
                              ? Colors.red.shade50
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: esFavorito
                                ? Colors.red.shade200
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              esFavorito
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: esFavorito ? Colors.red : Colors.grey,
                              size: 16,
                            ),
                             SizedBox(width: 6),
                            Text(
                              esFavorito
                                  ? 'Guardado en Favoritos'
                                  : 'No está en favoritos',
                              style: TextStyle(
                                color: esFavorito
                                    ? Colors.red.shade800
                                    : Colors.grey.shade700,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                       Spacer(),
                      Container(
                        padding:  EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Destino Turístico',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    lugar.nombre,
                    style:  TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: Color(0xFF1E293B),
                    ),
                  ),

                   SizedBox(height: 8),
                  Row(
                    children: [
                       Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                       SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          lugar.ubicacion,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                   SizedBox(height: 24),
                   Divider(height: 1, color: Color(0xFFE2E8F0)),
                   SizedBox(height: 20),
                   Text(
                    'Acerca del lugar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    lugar.descripcion,
                    style:  TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF475569),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: esFavorito
                            ? Colors.red.shade600
                            : Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 1,
                      ),
                      onPressed: () {
                        context
                            .read<TurismoViewModel>()
                            .alternarFavorito(lugar.id);
                      },
                      icon: Icon(
                        esFavorito ? Icons.favorite : Icons.favorite_border,
                      ),
                      label: Text(
                        esFavorito
                            ? 'Quitar de mis favoritos'
                            : 'Agregar a mis favoritos',
                        style:  TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                   SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
