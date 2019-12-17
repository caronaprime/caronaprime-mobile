import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:carona_prime/app/pages/novo_grupo/grupo_viewmodel.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simple_permissions/simple_permissions.dart';

class NovoGrupoBloc extends BlocBase {
  GrupoViewModel _grupoViewModel = GrupoViewModel();
  var localPartidaTextController = TextEditingController();
  var localDestinoTextController = TextEditingController();
  var nomeGrupoTextController = TextEditingController();
  var buscarContatosTextController = TextEditingController();

  var _grupoController = BehaviorSubject<GrupoViewModel>();
  Observable<GrupoViewModel> get outGrupo => _grupoController.stream;

  void setNomeGrupo(String nome) {
    _grupoViewModel.nome = nome;
    _grupoController.sink.add(_grupoViewModel);
  }

  setIndex(int index) {
    _grupoViewModel.pageIndex = index;
    _grupoController.sink.add(_grupoViewModel);
  }

  Future loadPosicaoInicial() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.low);
    if (position != null) {
      _grupoViewModel.posicaoInicial =
          LocalModel("", position.latitude, position.longitude, "");
      _grupoController.sink.add(_grupoViewModel);
    }
  }

  void filtrarContatos(String query) {
    if (query.isEmpty) {
      _grupoViewModel.contatosFiltrados = _grupoViewModel.todosContatos;
    } else {
      _grupoViewModel.contatosFiltrados = _grupoViewModel.todosContatos.where(
          (contact) =>
              contact.displayName.toUpperCase().contains(query.toUpperCase()));
    }

    _grupoController.sink.add(_grupoViewModel);
  }

  void loadContacts(String query) async {
    try {
      await SimplePermissions.requestPermission(Permission.ReadContacts);
      if (await SimplePermissions.checkPermission(Permission.ReadContacts)) {
        _grupoViewModel.todosContatos =
            await ContactsService.getContacts(query: query);
        filtrarContatos(query);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void adicionarContatoSelecionado(Contact contact) {
    _grupoViewModel.contatosSelecionados.add(contact);
    _grupoController.sink.add(_grupoViewModel);
  }

  void removerContatoSelecionado(Contact contact) {
    _grupoViewModel.contatosSelecionados.remove(contact);
    _grupoController.sink.add(_grupoViewModel);
  }

  void setLocalDePartida(LocalModel local) {
    if (local != null) {
      localPartidaTextController.text = local.nome;

      _grupoViewModel.makerPartida = Marker(
          markerId: MarkerId(local.nome),
          position: LatLng(local.latitude, local.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "Local de partida: " + local.nome));
    }
    _grupoViewModel.localDePartida = local;
    _grupoController.sink.add(_grupoViewModel);
  }

  void setLocalDeDestino(LocalModel local) {
    if (local != null) {
      localDestinoTextController.text = local.nome;

      _grupoViewModel.markerDestino = Marker(
          markerId: MarkerId(local.nome),
          position: LatLng(local.latitude, local.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "Local de destino: " + local.nome));
    }
    _grupoViewModel.localDeDestino = local;
    _grupoController.sink.add(_grupoViewModel);
  }

  LocalModel get localDePartida => _grupoViewModel.localDePartida;
  LocalModel get localDeDestino => _grupoViewModel.localDeDestino;

  Future loadPoints() async {
    if (_grupoViewModel.localDePartida == null || _grupoViewModel.localDeDestino == null) return;

    PolylinePoints polylinePoints = PolylinePoints();
    var points = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDny8aAA0AA9LBWNAkNONtTwVLFJz7u6Fo",
        _grupoViewModel.localDePartida.latitude,
        _grupoViewModel.localDePartida.longitude,
        _grupoViewModel.localDeDestino.latitude,
        _grupoViewModel.localDeDestino.longitude);

    var latLongs = List<LatLng>();
    for (var point in points) {
      latLongs.add(LatLng(point.latitude, point.longitude));
    }
    _grupoViewModel.polyLinePoints = latLongs;
  }

  Future loadPointsAndMarkers() async {
    var markers = List<Marker>();
    if (_grupoViewModel.makerPartida != null)
      markers.add(_grupoViewModel.makerPartida);
    if (_grupoViewModel.markerDestino != null)
      markers.add(_grupoViewModel.markerDestino);

    await loadPoints();

    _grupoViewModel.markers = markers.toSet();
    _grupoController.sink.add(_grupoViewModel);
  }

  @override
  void dispose() {
    _grupoController.close();
    super.dispose();
  }
}
