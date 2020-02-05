import 'package:carona_prime/app/models/carona_model.dart';
import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'carona_resposta_model.g.dart';

@JsonSerializable()
class CaronaRespostaModel {
  int id;

  bool aceitou;
  int caronaId;
  int usuarioId;

  @JsonKey(name: "caronaResposta")
  CaronaModel carona;
  UsuarioModel usuario;

  CaronaRespostaModel();

  factory CaronaRespostaModel.fromJson(Map<String, dynamic> json) =>
      _$CaronaRespostaModelFromJson(json);
  Map<String, dynamic> toJson(CaronaRespostaModel model) =>
      _$CaronaRespostaModelToJson(this);
}
