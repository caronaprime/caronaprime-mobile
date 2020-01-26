import 'package:json_annotation/json_annotation.dart';

part 'latlng_model.g.dart';

@JsonSerializable()
class LatLngModel{
  double latitude;
  double longitude;

  LatLngModel(this.latitude, this.longitude);

  factory LatLngModel.fromJson(Map<String, dynamic> json) => _$LatLngModelFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngModelToJson(this);

}