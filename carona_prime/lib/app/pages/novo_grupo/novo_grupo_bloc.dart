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

class SelecionarContatosViewModel {
  List<Contact> contatosSelecionados = List<Contact>();
  Iterable<Contact> contatosFiltrados = List<Contact>();

  SelecionarContatosViewModel(
      {this.contatosSelecionados, this.contatosFiltrados});
}

class MapaViewModel {
  Set<Marker> markers = Set<Marker>();
  List<LatLng> polyLinePoints = List<LatLng>();
  MapaViewModel({this.markers, this.polyLinePoints});
}

class NovoGrupoBloc extends BlocBase {
  GrupoViewModel _grupoViewModel = GrupoViewModel();
  var localPartidaTextController = TextEditingController();
  var localDestinoTextController = TextEditingController();
  var nomeGrupoTextController = TextEditingController();
  var buscarContatosTextController = TextEditingController();

  var _nomeGrupoController = BehaviorSubject<String>();
  Observable<String> get outNomeGrupo => _nomeGrupoController.stream;

  var _selecionarContatosController =
      BehaviorSubject<SelecionarContatosViewModel>();
  Observable<SelecionarContatosViewModel> get outSelecionarContatosViewModel =>
      _selecionarContatosController.stream;

  var _mapaController = BehaviorSubject<MapaViewModel>();
  Observable<MapaViewModel> get outMapaViewModel => _mapaController.stream;

  var _posicaoInicialController = BehaviorSubject<LocalModel>();
  Observable<LocalModel> get outPosicaoInicial =>
      _posicaoInicialController.stream;

  var _nomeLocalPartidaController = BehaviorSubject<String>();
  Observable<String> get outNomeLocalPartida =>
      _nomeLocalPartidaController.stream;

  var _nomeLocalDestinoController = BehaviorSubject<String>();
  Observable<String> get outNomeLocalDestino =>
      _nomeLocalDestinoController.stream;

  var _pageIndexController = BehaviorSubject<int>();
  Observable<int> get outPageIndex => _pageIndexController.stream;

  void setNomeGrupo(String nome) {
    _grupoViewModel.nome = nome;
    _nomeGrupoController.sink.add(nome);
  }

  void cancelar() {
    _grupoViewModel = GrupoViewModel();
    loadContacts("");

    buscarContatosTextController.clear();
    localDestinoTextController.clear();
    localPartidaTextController.clear();
    nomeGrupoTextController.clear();

    // _grupoController.sink.add(_grupoViewModel);
  }

  setIndex(int index) {
    _grupoViewModel.pageIndex = index;
    _pageIndexController.sink.add(index);
  }

  Future loadPosicaoInicial() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.low);
    if (position != null) {
      _grupoViewModel.posicaoInicial =
          LocalModel("", position.latitude, position.longitude, "");
      _posicaoInicialController.sink.add(_grupoViewModel.posicaoInicial);
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
    var contatosViewModel = SelecionarContatosViewModel(
        contatosSelecionados: _grupoViewModel.contatosSelecionados,
        contatosFiltrados: _grupoViewModel.contatosFiltrados);
    _selecionarContatosController.sink.add(contatosViewModel);
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
    var contatosViewModel = SelecionarContatosViewModel(
        contatosSelecionados: _grupoViewModel.contatosSelecionados,
        contatosFiltrados: _grupoViewModel.contatosFiltrados);
    _selecionarContatosController.sink.add(contatosViewModel);
  }

  void removerContatoSelecionado(Contact contact) {
    _grupoViewModel.contatosSelecionados.remove(contact);
    var contatosViewModel = SelecionarContatosViewModel(
        contatosSelecionados: _grupoViewModel.contatosSelecionados,
        contatosFiltrados: _grupoViewModel.contatosFiltrados);
    _selecionarContatosController.sink.add(contatosViewModel);
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
    _nomeLocalPartidaController.sink.add(local.nome);
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
    _nomeLocalDestinoController.sink.add(local.nome);
  }

  LocalModel get localDePartida => _grupoViewModel.localDePartida;
  LocalModel get localDeDestino => _grupoViewModel.localDeDestino;

  Future loadPoints() async {
    if (_grupoViewModel.localDePartida == null ||
        _grupoViewModel.localDeDestino == null) return;

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
    _mapaController.sink.add(MapaViewModel(
        markers: _grupoViewModel.markers,
        polyLinePoints: _grupoViewModel.polyLinePoints));
  }

  @override
  void dispose() {
    _nomeGrupoController.close();
    _selecionarContatosController.close();
    _mapaController.close();
    _posicaoInicialController.close();
    _nomeLocalPartidaController.close();
    _nomeLocalDestinoController.close();
    _pageIndexController.close();
    super.dispose();
  }
}
