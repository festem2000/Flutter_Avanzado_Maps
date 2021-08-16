part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(builder: (context, state) {
      if (state.seleccionManual) {
        return Container();
      } else {
        return FadeInDown(
            duration: Duration(milliseconds: 300),
            child: buildSearchbar(context));
      }
    });
  }

  Widget buildSearchbar(BuildContext context) {
    final media = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: media,
        child: GestureDetector(
          onTap: () async {
            final proximidad = context.bloc<MiUbicacionBloc>().state.ubicacion;
            final historial = context.bloc<BusquedaBloc>().state.historial;

            final resultado = await showSearch(
                context: context,
                delegate: SearchDestination(proximidad, historial));
            this.retornoBusqueda(context, resultado);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            width: double.infinity,
            child: Text(
              '¿ Donde quieres ir?',
              style: TextStyle(color: Colors.black87),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5))
                ]),
          ),
        ),
      ),
    );
  }

  void retornoBusqueda(BuildContext context, SearchResult result) async {
    if (result.cancelo) return;

    if (result.manual) {
      context.bloc<BusquedaBloc>().add(OnActivarMarcadorManual());
      return;
    }

    calculandoAlerta(context);

    /// Calcular la ruta en base al valor: Result
    final trafficService = new TrafficService();

    final mapaBloc = context.bloc<MapaBloc>();

    final inicio = context.bloc<MiUbicacionBloc>().state.ubicacion;
    final destino = result.position;

    final drivingTraffic =
        await trafficService.getCoordsInicioYFin(inicio, destino);

    final geometry = drivingTraffic.routes[0].geometry;
    final duracion = drivingTraffic.routes[0].duration;
    final distancia = drivingTraffic.routes[0].distance;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6);

    final List<LatLng> rutaCoordenadas = points.decodedCoords
        .map(
          (points) => LatLng(points[0], points[1]),
        )
        .toList();

    mapaBloc
      ..add(OnCrearrutaInicioDestino(rutaCoordenadas, distancia, duracion));

    Navigator.pop(context);

    /// Agregar al historial
    final busquedaBloc = context.bloc<BusquedaBloc>();
    busquedaBloc.add(OnAgregarHistorial(result));
  }
}
