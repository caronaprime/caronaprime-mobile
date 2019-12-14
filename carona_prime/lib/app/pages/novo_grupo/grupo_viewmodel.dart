import 'package:carona_prime/app/models/local_model.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GrupoViewModel {
  int pageIndex = 0;
  Marker makerPartida;
  Marker markerDestino;
  List<Contact> contatosSelecionados = List<Contact>();
  String nome = "Novo Grupo";
  Iterable<Contact> contatosFiltrados = List<Contact>();
  Iterable<Contact> todosContatos = List<Contact>();
  LocalModel posicaoInicial;
  LocalModel localDePartida;
  LocalModel localDeDestino;
  Set<Marker> markers = Set<Marker>();
  List<LatLng> polyLinePoints = List<LatLng>();
}
