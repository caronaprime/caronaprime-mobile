import 'package:json_annotation/json_annotation.dart';

part 'oferta_carona_model.g.dart';

@JsonSerializable()
class OfertaCaronaModel {
  int grupoId;
  bool portaMalasLivre;
  bool carroAdaptado;
  int hora;
  int minuto;
  int totalVagas;
  bool domingo;
  bool segunda;
  bool terca;
  bool quarta;
  bool quinta;
  bool sexta;
  bool sabado;
  bool repertirSemanalmente;
  int usuarioId;

  OfertaCaronaModel();

  factory OfertaCaronaModel.fromJson(Map<String, dynamic> json) =>
      _$OfertaCaronaModelFromJson(json);
  Map<String, dynamic> toJson() => _$OfertaCaronaModelToJson(this);
}
