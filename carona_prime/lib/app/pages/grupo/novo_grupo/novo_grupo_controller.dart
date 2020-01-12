import 'package:carona_prime/app/models/local_model.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_permissions/simple_permissions.dart';

part 'novo_grupo_controller.g.dart';

class NovoGrupoController = NovoGrupoBase with _$NovoGrupoController;

abstract class NovoGrupoBase with Store {
  @observable
  LocalModel localDePartida;

  @observable
  LocalModel localDeDestino;

  @observable
  ObservableList<LatLng> polyLinePoints = ObservableList<LatLng>();

  @observable
  ObservableList<Marker> markers = ObservableList<Marker>();

  @observable
  Marker makerPartida;

  @observable
  Marker markerDestino;

  @observable
  String query = "";

  @observable
  String nomeGrupo = "";

  @observable
  ObservableList<Contact> todosContatos = ObservableList<Contact>();

  @observable
  ObservableList<Contact> contatosSelecionados = ObservableList<Contact>();

  @computed
  List<Contact> get contatosFiltrados {
    if (query != null && query.isNotEmpty)
      return todosContatos
          .where(
              (c) => c.displayName.toUpperCase().contains(query.toUpperCase()))
          .toList();

    return todosContatos;
  }

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

  @action
  cancelar() => print("implementar");

  @action
  Future loadContacts() async {
    try {
      await SimplePermissions.requestPermission(Permission.ReadContacts);
      if (await SimplePermissions.checkPermission(Permission.ReadContacts)) {
        var contatos = await ContactsService.getContacts();
        todosContatos.clear();
        todosContatos.addAll(contatos);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @action
  setPosicaoInicial(LocalModel value) => posicaoInicial = value;

  @action
  setQuery(String value) => query = value;

  @action
  Future loadPosicaoInicial() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.low);
    if (position != null) {
      posicaoInicial =
          LocalModel("", position.latitude, position.longitude, "");

      setPosicaoInicial(posicaoInicial);
    }
  }

  @action
  Future loadPointsAndMarkers() async {
    markers.clear();
    if (makerPartida != null) markers.add(makerPartida);
    if (markerDestino != null) markers.add(markerDestino);

    await loadPoints();
  }

  @action
  Future loadPoints() async {
    if (localDePartida == null || localDeDestino == null) return;

    PolylinePoints polylinePoints = PolylinePoints();
    var points = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDny8aAA0AA9LBWNAkNONtTwVLFJz7u6Fo",
        localDePartida.latitude,
        localDePartida.longitude,
        localDeDestino.latitude,
        localDeDestino.longitude);

    for (var point in points) {
      polyLinePoints.add(LatLng(point.latitude, point.longitude));
    }    
  }

  @action
  void adicionarContatoSelecionado(Contact contact) =>
      contatosSelecionados.add(contact);

  @action
  void removerContatoSelecionado(Contact contact) =>
      contatosSelecionados.remove(contact);

  @action
  void setLocalDeDestino(LocalModel local) {
    if (local != null) {
      nomeLocalDestino = local.nome;

      markerDestino = Marker(
          markerId: MarkerId(local.nome),
          position: LatLng(local.latitude, local.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "Local de destino: " + local.nome));
    }
    localDeDestino = local;
    nomeLocalDestino = local.nome;
  }

  @action
  void setLocalDePartida(LocalModel local) {
    if (local != null) {
      nomeLocalPartida = local.nome;

      makerPartida = Marker(
          markerId: MarkerId(local.nome),
          position: LatLng(local.latitude, local.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "Local de partida: " + local.nome));
    }
    localDePartida = local;
    nomeLocalPartida = local.nome;
  }
}
