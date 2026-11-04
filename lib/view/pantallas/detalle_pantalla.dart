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
    // 1. Obtención de datos mediante arguments de la ruta nombrada
    final Object? args = ModalRoute.of(context)?.settings.arguments;

    // ViewModel observado con context.watch()
    final viewModel = context.watch<TurismoViewModel>();

    // Si se pasa por arguments se usa, de lo contrario fallback al lugar del ViewModel
    final LugarTuristico? lugar = (args is LugarTuristico)
        ? args
        : (viewModel.lugarSeleccionado ??
            (viewModel.lugares.isNotEmpty ? viewModel.lugares.first : null));

    if (lugar == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle del Lugar')),
        body: const Center(
          child: Text('No se encontraron datos del lugar turístico.'),
        ),
      );
    }

    // Comprobar si el lugar actual está en favoritos
    final bool esFavorito = viewModel.esFavorito(lugar.id);
    final int indiceActual = viewModel.indiceImagenActual;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: CustomScrollView(
        slivers: [
          // AppBar colapsable con la galería de imágenes deslizables
          SliverAppBar(
            expandedHeight: 340.0,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: const Color(0x73000000),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              // Icono que muestra y permite alternar si el lugar está guardado en favoritos
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CircleAvatar(
                  backgroundColor: const Color(0x73000000),
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
                  // Gesto 2: Deslizamiento horizontal para recorrer la galería de imágenes
                  PageView.builder(
                    controller: _pageController,
                    itemCount: lugar.imagenes.length,
                    onPageChanged: (indice) {
                      // Actualiza el índice en TurismoViewModel usando context.read()
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
                            child: const Center(
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
                                const Icon(
                                  Icons.landscape_rounded,
                                  size: 64,
                                  color: Colors.white70,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  lugar.nombre,
                                  style: const TextStyle(
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

                  // Gradiente inferior para mejorar contraste visual
                  const Positioned.fill(
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

                  // Indicador del gesto de deslizamiento y contador de imágenes
                  Positioned(
                    bottom: 16,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Puntos indicadores de páginas (Dots)
                        Row(
                          children: List.generate(
                            lugar.imagenes.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: indiceActual == i ? 22 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: indiceActual == i
                                    ? Colors.white
                                    : const Color(0x73FFFFFF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),

                        // Badge con número de foto y ayuda visual de deslizamiento
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x8C000000),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.swipe,
                                size: 14,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${indiceActual + 1}/${lugar.imagenes.length}',
                                style: const TextStyle(
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

          // Contenido principal de la pantalla de detalle
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Estado de favorito destacado
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
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
                            const SizedBox(width: 6),
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
                      const Spacer(),
                      // Etiqueta de Atractivo Turístico
                      Container(
                        padding: const EdgeInsets.symmetric(
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

                  const SizedBox(height: 16),

                  // Nombre del Lugar Turístico
                  Text(
                    lugar.nombre,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: Color(0xFF1E293B),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Ubicación del lugar con icono
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
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

                  const SizedBox(height: 24),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 20),

                  // Sección "Acerca del lugar" (Descripción)
                  const Text(
                    'Acerca del lugar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    lugar.descripcion,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF475569),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Tarjeta explicativa del Gesto 2 implementado
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.blue.shade100),
                    ),
                    color: const Color(0x1F2196F3),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.touch_app_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Gesto 2: Deslizamiento horizontal',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Desliza la fotografía superior hacia la izquierda o derecha para ver la galería completa y actualizar el estado en el ViewModel.',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Botón de acción para marcar/desmarcar favoritos directamente
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
