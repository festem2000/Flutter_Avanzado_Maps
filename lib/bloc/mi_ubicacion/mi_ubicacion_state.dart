part of 'mi_ubicacion_bloc.dart';

@immutable
class MiUbicacionState {
  //PROPIEDADES

  // Seguir la ubicacion
  final bool siguiendo;

  /// Permite validar la ultima ubicacion de la persona ===
  /// TRUE = Si tenemos la ultima ubicacion
  /// FALSE = Si es lo contrario
  final bool existeUbicacion;

  /// Coordenadas donde esta el usuario
  final LatLng ubicacion;

  MiUbicacionState(
      {this.siguiendo = true, this.existeUbicacion = false, this.ubicacion});

  MiUbicacionState copyWith({
    bool siguiendo,
    bool existeUbicacion,
    LatLng ubicacion,
  }) =>
      new MiUbicacionState(
        // Si existe un valor en siguiendo establecerselo
        siguiendo: siguiendo ?? this.siguiendo,
        // Si existe un valor en existeUbicacion establecerselo
        existeUbicacion: existeUbicacion ?? this.existeUbicacion,
        // Si existe un valor en ubicacion establecerselo
        ubicacion: ubicacion ?? this.ubicacion,
      );
}
