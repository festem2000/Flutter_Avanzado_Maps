import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/themes/uber_map_theme.dart';
import 'package:meta/meta.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(MapaState());

  ///Controlador del mapa
  GoogleMapController _mapController;

  /// Polylines
  Polyline _miRuta = new Polyline(
    polylineId: PolylineId('mi_ruta'),
    width: 4,
    color: Colors.transparent,
  );

  /// Polylines
  Polyline _miRutaDestino = new Polyline(
      polylineId: PolylineId('mi_ruta_destino'),
      width: 4,
      color: Colors.black87);

  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      this._mapController = controller;

      this._mapController.setMapStyle(jsonEncode(uberMapthme));

      add(OnMapaListo());
    }
  }

  void moverCamara(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);

    this._mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: destino, zoom: 15),
        ));
  }

  @override
  Stream<MapaState> mapEventToState(
    MapaEvent event,
  ) async* {
    if (event is OnMapaListo) {
      yield state.copyWith(mapaListo: true);
    } else if (event is OnNuevaUbicacion) {
      /// Solo extraer la logica del stream para eso funciona el *
      yield* this._onNuevaUbicacion(event);
    } else if (event is OnMarcarRecorrido) {
      ///
      yield* this._onMarcarRecorrido(event);
    } else if (event is OnSeguirUbicacion) {
      ///
      yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
    } else if (event is OnMovioMapa) {
      ///
      yield state.copyWith(ubicacionCentral: event.centroMapa);
    } else if (event is OnCrearrutaInicioDestino) {
      ///
      yield* this._onCrearRutaInicioDestino(event);
    }
  }

  Stream<MapaState> _onNuevaUbicacion(OnNuevaUbicacion event) async* {
    if (state.seguirUbicacion) {
      this.moverCamara(event.ubicacion);
    }

    final points = [...this._miRuta.points, event.ubicacion];

    this._miRuta = this._miRuta.copyWith(pointsParam: points);

    final currentPolyLines = state.polylines;

    currentPolyLines['mi_ruta'] = this._miRuta;

    yield state.copyWith(polylines: currentPolyLines);
  }

  Stream<MapaState> _onMarcarRecorrido(OnMarcarRecorrido event) async* {
    if (!state.dibujarRecorrido) {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.black87);
    } else
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.transparent);

    final currentPolyLines = state.polylines;

    currentPolyLines['mi_ruta'] = this._miRuta;

    yield state.copyWith(
        dibujarRecorrido: !state.dibujarRecorrido, polylines: currentPolyLines);
  }

  Stream<MapaState> _onCrearRutaInicioDestino(
      OnCrearrutaInicioDestino event) async* {
    this._miRutaDestino =
        this._miRutaDestino.copyWith(pointsParam: event.rutaCoordendas);

    final currentPolyLines = state.polylines;

    currentPolyLines['mi_ruta_destino'] = this._miRutaDestino;

    yield state.copyWith(
      polylines: currentPolyLines,
      // TODO: Marcadores
    );
  }
}
