import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'mi_ubicacion_event.dart';
part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  MiUbicacionBloc() : super(MiUbicacionState());

  StreamSubscription<Geolocator.Position> _positionSubscription;

  void iniciarSeguimiento() {
    this._positionSubscription = Geolocator.getPositionStream(
      // Presicion de la ubicacion (esto entre mas preciso es mas bateria consume)
      desiredAccuracy: Geolocator.LocationAccuracy.high,
      // emitir cada que se cambia ciertos metros el dispositivo
      distanceFilter: 10,
    ).listen((Geolocator.Position position) {
      final nuevaUbicacion = new LatLng(position.latitude, position.longitude);

      // Esta llamando al evento
      add(OnUbicacionCambio(nuevaUbicacion));
    });
  }

  void cancelarSeguimiento() {
    /// Cancelar el seguimiento si existe
    this._positionSubscription?.cancel();
  }

  @override
  Stream<MiUbicacionState> mapEventToState(MiUbicacionEvent event) async* {
    /// Para verificar si tenemos una nueva ubicacion
    if (event is OnUbicacionCambio) {
      // Para emitir un nuevo estado
      yield state.copyWith(
        existeUbicacion: true,
        ubicacion: event.ubicacion,
      );
    }
  }
}
