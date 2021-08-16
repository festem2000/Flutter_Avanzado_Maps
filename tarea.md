# Tarea:

1. Crear una propiedad en el MapaState llamada:
    ```final LatLng ubicacionCentral;```

2. Crear un evento para cambiarla llamado:
    OnMovioMapa

3. El evento ```OnMovioMapa```, debe tener una propiedad final llamada:
    centroMapa de tipo LatLng 
    (No se olviden de añadirla en el constructor del evento)

4. En el ```MapaBloc```, en el método ```mapEventToState```, únicamente necesito que establezcan el valor del estado ```ubicacionCentral```, al valor de la propiedad que viene en el evento.

5. En el archivo ```mapa_page.dart```, en el widget GoogleMap, hay una propiedad que nos ayuda a saber cuando el mapa se mueve, la cual es ```onCameraMove```, podemos definir el evento que queremos que se ejecute así:

```
onCameraMove: ( cameraPosition ) {
    // cameraPosition.target = LatLng central del mapa
    mapaBloc.add( OnMovioMapa( cameraPosition.target ));
},
```

6. Para probar que funcione todo, hagan un print en el MapaBloc, específicamente en el método mapEventToState, cuando reciben un evento de tipo ```OnMovioMapa```:
    print(event.centroMapa);    



