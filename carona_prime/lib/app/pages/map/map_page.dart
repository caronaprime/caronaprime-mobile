import 'package:carona_prime/app/app_module.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:carona_prime/app/pages/map/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final LocalModel localDePartida;
  final LocalModel localDeDestino;
  final _bloc = AppModule.to.bloc<MapBloc>();

  MapPage(this.localDePartida, this.localDeDestino);

  @override
  _MapPageState createState() =>
      _MapPageState(localDePartida, localDeDestino, _bloc);
}

class _MapPageState extends State<MapPage> {
  final LocalModel localDePartida;
  final LocalModel localDeDestino;
  final MapBloc bloc;
  _MapPageState(this.localDePartida, this.localDeDestino, this.bloc) {
    bloc.loadPolyCordinates(localDePartida, localDeDestino);
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId(localDePartida.nome),
          position: LatLng(localDePartida.latitude, localDePartida.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: localDePartida.nome)),
      Marker(
          markerId: MarkerId(localDeDestino.nome),
          position: LatLng(localDeDestino.latitude, localDeDestino.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: localDeDestino.nome))
    ].toSet();
  }

  Set<Polyline> _createPolylines() {
    return <Polyline>[
      Polyline(
        polylineId: PolylineId("_lastMapPosition.toString()"),
        visible: true,
        // points: points(),
        color: Colors.blue,
      )
    ].toSet();
  }

  Future<List<PointLatLng>> points() async {
    PolylinePoints polylinePoints = PolylinePoints();
    var points = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDny8aAA0AA9LBWNAkNONtTwVLFJz7u6Fo",
        widget.localDePartida.latitude,
        widget.localDePartida.longitude,
        widget.localDeDestino.latitude,
        widget.localDeDestino.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: StreamBuilder<Set<Polyline>>(
        stream: bloc.outPoints,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? GoogleMap(
                  mapType: MapType.normal,
                  markers: _createMarker(),
                  polylines: snapshot.data,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          localDePartida.latitude, localDePartida.longitude),
                      zoom: 12),
                )
              : CircularProgressIndicator(
                  backgroundColor: Colors.black,
                );
        },
      ),
    );
  }
}
