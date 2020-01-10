import 'package:carona_prime/app/models/local_model.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_permissions/simple_permissions.dart';

import 'novo_grupoVM.dart';
part 'novo_grupo_controller.g.dart';

class NovoGrupoController = NovoGrupoBase with _$NovoGrupoController;

abstract class NovoGrupoBase with Store {
  var localPartidaTextController = TextEditingController();
  var localDestinoTextController = TextEditingController();
  var nomeGrupoTextController = TextEditingController();
  var buscarContatosTextController = TextEditingController();

  @observable
  GrupoViewModel grupoViewModel = GrupoViewModel();

  @observable
  String nomeGrupo = "";

  @observable
  SelecionarContatosViewModel selecionarContatosViewModel =
      SelecionarContatosViewModel();

  @observable
  MapaViewModel mapaViewModel = MapaViewModel();

  @observable
  LocalModel posicaoInicial;

  @observable
  String nomeLocalPartida = "";

  @observable
  String nomeLocalDestino = "";

  @observable
  int pageIndex = 0;

  @action
  void setPageIndex(int value) => pageIndex = value;

  @action
  void setNomeGrupo(String value) => nomeGrupo = value;

  @action cancelar() => print("implementar");

  @action
  Future loadContacts(String query) async {
    try {
      await SimplePermissions.requestPermission(Permission.ReadContacts);
      if (await SimplePermissions.checkPermission(Permission.ReadContacts)) {
        grupoViewModel.todosContatos =
            await ContactsService.getContacts(query: query);
        filtrarContatos(query);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @action
  setSelecionarContatos(SelecionarContatosViewModel value) =>
      selecionarContatosViewModel = value;

  @action
  setPosicaoInicial(LocalModel value) => posicaoInicial = value;

  @action
  void filtrarContatos(String query) {
    if (query.isEmpty) {
      grupoViewModel.contatosFiltrados = grupoViewModel.todosContatos;
    } else {
      grupoViewModel.contatosFiltrados = grupoViewModel.todosContatos.where(
          (contact) =>
              contact.displayName.toUpperCase().contains(query.toUpperCase()));
    }
    var contatosViewModel = SelecionarContatosViewModel(
        contatosSelecionados: grupoViewModel.contatosSelecionados,
        contatosFiltrados: grupoViewModel.contatosFiltrados);
    setSelecionarContatos(contatosViewModel);
  }

  @action
  Future loadPosicaoInicial() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.low);
    if (position != null) {
      grupoViewModel.posicaoInicial =
          LocalModel("", position.latitude, position.longitude, "");

      setPosicaoInicial(grupoViewModel.posicaoInicial);
    }
  }

  @action
  Future loadPointsAndMarkers() async {
    var markers = List<Marker>();
    if (grupoViewModel.makerPartida != null)
      markers.add(grupoViewModel.makerPartida);
    if (grupoViewModel.markerDestino != null)
      markers.add(grupoViewModel.markerDestino);

    await loadPoints();

    grupoViewModel.markers = markers.toSet();
    mapaViewModel = MapaViewModel(
        markers: grupoViewModel.markers,
        polyLinePoints: grupoViewModel.polyLinePoints);
  }

  @action
  Future loadPoints() async {
    if (grupoViewModel.localDePartida == null ||
        grupoViewModel.localDeDestino == null) return;

    PolylinePoints polylinePoints = PolylinePoints();
    var points = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDny8aAA0AA9LBWNAkNONtTwVLFJz7u6Fo",
        grupoViewModel.localDePartida.latitude,
        grupoViewModel.localDePartida.longitude,
        grupoViewModel.localDeDestino.latitude,
        grupoViewModel.localDeDestino.longitude);

    var latLongs = List<LatLng>();
    for (var point in points) {
      latLongs.add(LatLng(point.latitude, point.longitude));
    }
    grupoViewModel.polyLinePoints = latLongs;
  }

  @action
  void adicionarContatoSelecionado(Contact contact) {
    grupoViewModel.contatosSelecionados.add(contact);
    var contatosViewModel = SelecionarContatosViewModel(
        contatosSelecionados: grupoViewModel.contatosSelecionados,
        contatosFiltrados: grupoViewModel.contatosFiltrados);
    setSelecionarContatos(contatosViewModel);
  }

  @action
  void removerContatoSelecionado(Contact contact) {
    grupoViewModel.contatosSelecionados.remove(contact);
    var contatosViewModel = SelecionarContatosViewModel(
        contatosSelecionados: grupoViewModel.contatosSelecionados,
        contatosFiltrados: grupoViewModel.contatosFiltrados);
    setSelecionarContatos(contatosViewModel);
  }

  @action
  void setLocalDeDestino(LocalModel local) {
    if (local != null) {
      localDestinoTextController.text = local.nome;

      grupoViewModel.markerDestino = Marker(
          markerId: MarkerId(local.nome),
          position: LatLng(local.latitude, local.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "Local de destino: " + local.nome));
    }
    grupoViewModel.localDeDestino = local;
    nomeLocalDestino = local.nome;
  }

  @action
  void setLocalDePartida(LocalModel local) {
    if (local != null) {
      localPartidaTextController.text = local.nome;

      grupoViewModel.makerPartida = Marker(
          markerId: MarkerId(local.nome),
          position: LatLng(local.latitude, local.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "Local de partida: " + local.nome));
    }
    grupoViewModel.localDePartida = local;
    nomeLocalPartida = local.nome;    
  }
}
