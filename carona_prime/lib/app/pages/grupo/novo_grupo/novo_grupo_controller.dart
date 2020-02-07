import 'package:carona_prime/app/application_controller.dart';
import 'package:carona_prime/app/models/grupo_model.dart';
import 'package:carona_prime/app/models/latlng_model.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:carona_prime/app/models/membro_grupo_model.dart';
import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:carona_prime/app/shared/repositories/grupo_repository.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_permissions/simple_permissions.dart';

part 'novo_grupo_controller.g.dart';

class NovoGrupoController = NovoGrupoBase with _$NovoGrupoController;

abstract class NovoGrupoBase with Store {
  var _repository = GrupoRepository();
  var applicationController = GetIt.I.get<ApplicationController>();

  @observable
  bool carregouContato = false;

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

  String textNotEmptyValidator(String text) {
    if (text == null || text.isEmpty) return "Deve ser informado.";

    return null;
  }

  @observable
  ObservableList<Contact> todosContatos = ObservableList<Contact>();

  @observable
  ObservableList<Contact> contatosSelecionados = ObservableList<Contact>();

  @computed
  List<Contact> get contatosFiltrados {
    if (query != null && query.isNotEmpty)
      return todosContatos
          .where((c) =>
              c.displayName != null &&
              c.displayName.toUpperCase().contains(query.toUpperCase()))
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

  bool tudoPreenchido() =>
      contatosSelecionados.length > 0 &&
      localDePartida != null &&
      localDeDestino != null &&
      nomeGrupo.isNotEmpty;

  @action
  Future<bool> salvar() async {
    if (tudoPreenchido()) {
      List<MembroGrupoModel> membros = contatosSelecionados.map((c) {
        String numero = "";
        if (c.phones == null || c.phones.isEmpty)
          numero = "sem número";
        else
          numero = c.phones.first.value;

        return MembroGrupoModel(
            UsuarioModel(c.displayName ?? "Sem nome", numero), false);
      }).toList();      

      membros.add(MembroGrupoModel(applicationController.usuarioLogado, true));

      var latlongs = polyLinePoints
          .map((p) => LatLngModel(p.latitude, p.longitude))
          .toList();

      var grupo = GrupoModel()
        ..nome = nomeGrupo
        ..partida = localDePartida
        ..destino = localDeDestino
        ..membros = membros
        ..partida = localDePartida
        ..destino = localDeDestino
        ..latLongs = latlongs;

      var response = await _repository.postGrupo(grupo);
      return (response >= 200 && response < 300);
    }
    return true;
  }

  @action
  Future loadContacts() async {
    try {
      await SimplePermissions.requestPermission(Permission.ReadContacts);
      if (await SimplePermissions.checkPermission(Permission.ReadContacts)) {
        var contatos = await ContactsService.getContacts();
        todosContatos.clear();
        todosContatos.addAll(contatos);
        carregouContato = true;
      }
    } catch (e) {
      print(e.toString());
      carregouContato = false;
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
