import 'package:carona_prime/app/models/local_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'lista_grupos_response.g.dart';

@JsonSerializable()
class ListaGruposResponse{
  int id;
  String nome;  
  String descricao;

  @JsonKey(name: "partidaGrupo")
  LocalModel partida;
  @JsonKey(name: "destinoGrupo")
  LocalModel destino;
  ListaGruposResponse(this.id, this.nome, this.descricao, this.partida, this.destino);

  factory ListaGruposResponse.fromJson(Map<String, dynamic> json) => _$ListaGruposResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ListaGruposResponseToJson(this);
}