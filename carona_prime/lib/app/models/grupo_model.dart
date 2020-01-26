import 'package:carona_prime/app/models/local_model.dart';
import 'package:carona_prime/app/models/membro_grupo_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'latlng_model.dart';

part 'grupo_model.g.dart';

@JsonSerializable()
class GrupoModel {
  String nome;

  @JsonKey(name: "MembroGrupos")
  List<MembroGrupoModel> membros;

  @JsonKey(name: "LatLongs")
  List<LatLngModel> latLongs;

  @JsonKey(name: "partidaGrupo")
  LocalModel partida;
  @JsonKey(name: "destinoGrupo")
  LocalModel destino;

  GrupoModel();

  factory GrupoModel.fromJson(Map<String, dynamic> json) => _$GrupoModelFromJson(json);
  Map<String, dynamic> toJson() => _$GrupoModelToJson(this);
}
