part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

class OnMapaListo extends MapaEvent {}

class OnMarcarRecorrido extends MapaEvent {}

class OnSeguirUbicacion extends MapaEvent {}

class OnMovioMapa extends MapaEvent {
  final LatLng centroMapa;

  OnMovioMapa(this.centroMapa);
}

class OnCrearrutaInicioDestino extends MapaEvent {
  final List<LatLng> rutaCoordendas;
  final double distancia;
  final double duracion;

  OnCrearrutaInicioDestino(this.rutaCoordendas, this.distancia, this.duracion);
}

class OnNuevaUbicacion extends MapaEvent {
  final LatLng ubicacion;

  OnNuevaUbicacion(this.ubicacion);
}
