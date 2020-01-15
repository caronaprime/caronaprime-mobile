import 'package:json_annotation/json_annotation.dart';
part 'lista_grupos_response.g.dart';

@JsonSerializable()
class ListaGruposResponse{
  int id;
  String nome;
  String descricao;
  String partida;
  String destino;

  ListaGruposResponse(this.id, this.nome, this.descricao, this.partida, this.destino);

  factory ListaGruposResponse.fromJson(Map<String, dynamic> json) => _$ListaGruposResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ListaGruposResponseToJson(this);
}