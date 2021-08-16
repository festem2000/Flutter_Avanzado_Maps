part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (_, state) {
        if (state.seleccionManual) {
          return _BuildMarcadorManual();
        } else {
          return Container();
        }
      },
    );
  }
}

class _BuildMarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        /// Boton Regresar
        Positioned(
          top: 70,
          left: 20,
          child: FadeInLeft(
            duration: Duration(milliseconds: 50),
            child: CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  context
                      .bloc<BusquedaBloc>()
                      .add(OnDesactivarMarcadorManual());
                },
              ),
            ),
          ),
        ),

        Center(
          child: Transform.translate(
            offset: (Offset(0, -12)),
            child: BounceInDown(
              from: 200,
              child: Icon(
                Icons.location_on,
                size: 50,
              ),
            ),
          ),
        ),

        /// Boton de confirmar destino
        Positioned(
          bottom: 40,
          left: 40,
          child: FadeIn(
            child: MaterialButton(
                minWidth: width - 120,
                child: Text('Confirmar destino',
                    style: TextStyle(color: Colors.white)),
                color: Colors.black,
                shape: StadiumBorder(),
                elevation: 0,
                splashColor: Colors.transparent,
                onPressed: () {
                  this.calcularDestino(context);
                }),
          ),
        ),
      ],
    );
  }

  void calcularDestino(BuildContext context) async {
    calculandoAlerta(context);

    final mapaBloc = context.bloc<MapaBloc>();

    /// llamar nuesto servicio
    final trafficService = new TrafficService();

    final inicio = context.bloc<MiUbicacionBloc>().state.ubicacion;

    final destino = mapaBloc.state.ubicacionCentral;

    final trafficResponse =
        await trafficService.getCoordsInicioYFin(inicio, destino);

    final geometry = trafficResponse.routes[0].geometry;
    final duracion = trafficResponse.routes[0].duration;
    final distancia = trafficResponse.routes[0].distance;

    //Decodificar los puntos del geometry
    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;

    final List<LatLng> rutaCoords =
        points.map((point) => LatLng(point[0], point[1])).toList();

    mapaBloc.add(OnCrearrutaInicioDestino(rutaCoords, distancia, duracion));

    Navigator.of(context).pop();
    context.bloc<BusquedaBloc>().add(OnDesactivarMarcadorManual());
  }
}
