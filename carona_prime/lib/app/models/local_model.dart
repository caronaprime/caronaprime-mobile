import 'package:carona_prime/app/models/base_model.dart';

class LocalModel extends BaseModel {
  String _documentId;
  String nome;
  double longitude;
  double latitude;
  String placeId;
  String enderecoFormatado;

  LocalModel(this.nome, this.latitude, this.longitude, this.placeId);

  @override
  String documentId() => _documentId;

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['nome'] = this.nome;
    map['longitude'] = this.longitude;
    map['latitude'] = this.latitude;
    map['placeId'] = this.placeId;
    map['enderecoFormatado'] = this.enderecoFormatado;
    return map;
  }

  @override
  String toString() {
    return "Nome: ${this.nome}\nlatitude: ${this.latitude}\nlongitude: ${this.longitude}";
  }
}
