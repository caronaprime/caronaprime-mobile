import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carona_prime/app/models/local_model.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simple_permissions/simple_permissions.dart';

class NovoGrupoBloc extends BlocBase {
  var localPartidaTextController = TextEditingController();
  var localDestinoTextController = TextEditingController();
  var nomeGrupoTextController = TextEditingController();
  Marker _markerPartida;
  Marker _markerDestino;

  var _pageIndexController = BehaviorSubject<int>();
  Observable<int> get outPageIndex => _pageIndexController.stream;

  var _nomeGrupoController = BehaviorSubject<String>();
  Observable<String> get outNomeGrupo => _nomeGrupoController.stream;
  void setNomeGrupo(String nome) => _nomeGrupoController.sink.add(nome);

  setIndex(int index) => _pageIndexController.sink.add(index);
  var contatosSelecionados = List<Contact>();

  Iterable<Contact> _todosContatos = List<Contact>();
  Iterable<Contact> _contatosFiltrados = List<Contact>();

  var _contatosFiltradosController = BehaviorSubject<Iterable<Contact>>();
  Observable<Iterable<Contact>> get outContatosFiltrados =>
      _contatosFiltradosController.stream;

  var _posicaoInicialController = BehaviorSubject<LocalModel>();
  Observable<LocalModel> get outPosicaoInicial =>
      _posicaoInicialController.stream;

  Future loadPosicaoInicial() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.low);
    if (position != null)
      _posicaoInicialController.sink
          .add(LocalModel("", position.latitude, position.longitude, ""));
  }

  void filtrarContatos(String query) {
    if (query.isEmpty) {
      _contatosFiltradosController.sink.add(_todosContatos);
    } else {
      _contatosFiltrados = _todosContatos.where((contact) =>
          contact.displayName.toUpperCase().contains(query.toUpperCase()));
      _contatosFiltradosController.sink.add(_contatosFiltrados);
    }
  }

  var _contatosSelecionadosController = BehaviorSubject<List<Contact>>();
  Observable<List<Contact>> get outContatosSelecionados =>
      _contatosSelecionadosController.stream;

  void loadContacts(String query) async {
    try {
      await SimplePermissions.requestPermission(Permission.ReadContacts);
      if (await SimplePermissions.checkPermission(Permission.ReadContacts)) {
        _todosContatos = await ContactsService.getContacts(query: query);
        filtrarContatos(query);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void adicionarContatoSelecionado(Contact contact) {
    contatosSelecionados.add(contact);
    _contatosSelecionadosController.sink.add(contatosSelecionados);
  }

  void removerContatoSelecionado(Contact contact) {
    contatosSelecionados.remove(contact);
    _contatosSelecionadosController.sink.add(contatosSelecionados);
  }

  LocalModel _localDePartida;
  LocalModel _localDeDestino;

  var _localDePartidaController = BehaviorSubject<LocalModel>();

  Observable<LocalModel> get outLocalDePartida =>
      _localDePartidaController.stream;

  void setLocalDePartida(LocalModel local) {
    if (local != null) {
      localPartidaTextController.text = local.nome;

      _markerPartida = Marker(
          markerId: MarkerId(local.nome),
          position: LatLng(local.latitude, local.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "Local de partida: " + local.nome));
    }
    _localDePartida = local;
    _localDePartidaController.sink.add(local);
  }

  var _localDeDestinoController = BehaviorSubject<LocalModel>();

  Observable<LocalModel> get outLocalDeDestino =>
      _localDeDestinoController.stream;

  void setLocalDeDestino(LocalModel local) {
    if (local != null) {
      localDestinoTextController.text = local.nome;

      _markerDestino = Marker(
          markerId: MarkerId(local.nome),
          position: LatLng(local.latitude, local.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "Local de destino: " + local.nome));
    }
    _localDeDestino = local;
    _localDeDestinoController.sink.add(local);
  }

  LocalModel get localDePartida => _localDePartida;
  LocalModel get localDeDestino => _localDeDestino;

  var _pointsController = BehaviorSubject<Set<Polyline>>();
  Observable<Set<Polyline>> get outPoints => _pointsController.stream;

  var _markersController = BehaviorSubject<Set<Marker>>();
  Observable<Set<Marker>> get outMarkers => _markersController.stream;

  @override
  void dispose() {
    _pageIndexController.close();
    _contatosSelecionadosController.close();
    _contatosFiltradosController.close();
    _localDeDestinoController.close();
    _localDePartidaController.close();
    _pointsController.close();
    _markersController.close();
    _posicaoInicialController.close();
    _nomeGrupoController.close();
    super.dispose();
  }

  void loadMarkers() {
    var markers = List<Marker>();
    if (_markerPartida != null) markers.add(_markerPartida);
    if (_markerDestino != null) markers.add(_markerDestino);
    _markersController.sink.add(markers.toSet());
  }
}
