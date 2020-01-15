import 'package:json_annotation/json_annotation.dart';

part 'usuario_model.g.dart';

@JsonSerializable()
class UsuarioModel{
  String nome;
  String numeroCelelular;

  UsuarioModel(this.nome, this.numeroCelelular);

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => _$UsuarioModelFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioModelToJson(this);
}