import 'package:carona_prime/app/models/usuario_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'membro_grupo_model.g.dart';

@JsonSerializable()
class MembroGrupoModel {
  bool administrador;
  UsuarioModel usuario;

  MembroGrupoModel(this.usuario, this.administrador);


  factory MembroGrupoModel.fromJson(Map<String, dynamic> json) => _$MembroGrupoModelFromJson(json);
  Map<String, dynamic> toJson() => _$MembroGrupoModelToJson(this);
}
