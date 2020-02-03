import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'carona_model.g.dart';

@JsonSerializable()
class CaronaModel {
  int id;
  DateTime data;
  int hora;
  int minuto;
  int totalVagas;
  bool portaMalasLivre;
  bool carroAdaptado;
  int ofertaCaronaId;
  int grupoId;
  int usuarioId;

  @JsonKey(name: "caronaMotorista")
  UsuarioModel motorista;

  CaronaModel();

  factory CaronaModel.fromJson(Map<String, dynamic> json) => _$CaronaModelFromJson(json);
  Map<String, dynamic> toJson() => _$CaronaModelToJson(this);
}
