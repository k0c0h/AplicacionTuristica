import 'package:flutter/foundation.dart';
import '../models/lugar_turistico_model.dart';

class TurismoViewModel extends ChangeNotifier {
  // Lista de lugares turísticos predefinidos para la aplicación
  final List<LugarTuristico> _lugares = const [
    LugarTuristico(
      id: 1,
      nombre: 'Islas Galápagos',
      ubicacion: 'Galápagos, Ecuador',
      descripcion:
          'Un archipiélago volcánico en el Océano Pacífico, reconocido mundialmente por su biodiversidad única y especies endémicas. Es considerado un laboratorio natural vivo que inspiró la teoría de la evolución.',
      imagenes: [
        'https://images.unsplash.com/photo-1544735716-392fe2489ffa?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=1200&q=80',
      ],
    ),
    LugarTuristico(
      id: 2,
      nombre: 'Centro Histórico de Quito',
      ubicacion: 'Quito, Pichincha, Ecuador',
      descripcion:
          'El centro histórico más grande y mejor conservado de América. Con impresionantes iglesias coloniales, plazas adoquinadas y arquitectura barroca que lo convirtieron en el primer Patrimonio Cultural de la Humanidad por la UNESCO.',
      imagenes: [
        'https://images.unsplash.com/photo-1589556264800-08ae9e129a8c?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1596401057633-54a8fe8ef647?auto=format&fit=crop&w=1200&q=80',
      ],
    ),
    LugarTuristico(
      id: 3,
      nombre: 'Baños de Agua Santa',
      ubicacion: 'Tungurahua, Ecuador',
      descripcion:
          'El destino de aventura por excelencia en Ecuador, situado entre los Andes y la Amazonía. Famoso por la ruta de las cascadas como el Pailón del Diablo, deportes extremos y relajantes aguas termales.',
      imagenes: [
        'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=1200&q=80',
      ],
    ),
  ];

  // Estado administrado por Provider:
  // 1. Lugares favoritos (almacena los IDs de los lugares favoritos)
  final Set<int> _favoritos = {1};

  // 2. Lugar seleccionado
  LugarTuristico? _lugarSeleccionado;

  // 3. Índice de la imagen actual en la galería
  int _indiceImagenActual = 0;

  // Getters
  List<LugarTuristico> get lugares => _lugares;
  Set<int> get favoritos => _favoritos;
  LugarTuristico? get lugarSeleccionado => _lugarSeleccionado;
  int get indiceImagenActual => _indiceImagenActual;

  // Comprueba si un lugar está marcado como favorito
  bool esFavorito(int id) {
    return _favoritos.contains(id);
  }

  // Gesto 1 / Acción: Alterna el estado de favorito de un lugar
  void alternarFavorito(int id) {
    if (_favoritos.contains(id)) {
      _favoritos.remove(id);
    } else {
      _favoritos.add(id);
    }
    notifyListeners();
  }

  // Establece el lugar seleccionado para ver en detalle
  void seleccionarLugar(LugarTuristico lugar) {
    _lugarSeleccionado = lugar;
    _indiceImagenActual = 0;
    notifyListeners();
  }

  // Gesto 2 / Acción: Cambia el índice de la fotografía actual al deslizar horizontalmente
  void cambiarImagen(int indice) {
    if (_indiceImagenActual != indice) {
      _indiceImagenActual = indice;
      notifyListeners();
    }
  }

  // Reinicia el índice de imagen
  void reiniciarIndice() {
    _indiceImagenActual = 0;
    notifyListeners();
  }
}
