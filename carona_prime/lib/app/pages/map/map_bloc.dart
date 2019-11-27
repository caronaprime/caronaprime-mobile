import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class MapBloc extends BlocBase {
  var _pointsController = BehaviorSubject<Set<Polyline>>();

  Observable<Set<Polyline>> get outPoints => _pointsController.stream;

  void setPolyCordinates(List<PointLatLng> points) {
    var list = List<LatLng>();
    points?.forEach((PointLatLng point) {
      list.add(LatLng(point.latitude, point.latitude));
    });
    var _polylines = Set<Polyline>();
    _polylines.add(Polyline(
        polylineId: PolylineId("asdfadsf"),
        visible: true,
        points: list,
        color: Colors.red));
    _pointsController.sink.add(_polylines);
  }

  void loadPolyCordinates(
      LocalModel localDePartida, LocalModel localDeDestino) async {
    PolylinePoints polylinePoints = PolylinePoints();
    var points = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDny8aAA0AA9LBWNAkNONtTwVLFJz7u6Fo",
        localDePartida.latitude,
        localDePartida.longitude,
        localDeDestino.latitude,
        localDeDestino.longitude);
    setPolyCordinates(points);
  }

  @override
  void dispose() {
    _pointsController.close();
    super.dispose();
  }
}
