import 'package:json_annotation/json_annotation.dart';
part 'local_model.g.dart';

@JsonSerializable()
class LocalModel {
  String nome;
  double longitude;
  double latitude;
  String placeId;
  String enderecoFormatado;

  LocalModel(this.nome, this.latitude, this.longitude, this.placeId);

  factory LocalModel.fromJson(Map<String, dynamic> json) => _$LocalModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocalModelToJson(this);
}
