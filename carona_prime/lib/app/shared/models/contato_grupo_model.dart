import 'package:contacts_service/contacts_service.dart';
import 'base_model.dart';

class ContatoGrupoModel extends BaseModel {
  String _documentId;
  Contact nome;
  double longitude;
  double latitude;
  String placeId;

  @override
  String documentId()  => _documentId;

  @override
  toMap() {
    // TODO: implement toMap
    return null;
  }}