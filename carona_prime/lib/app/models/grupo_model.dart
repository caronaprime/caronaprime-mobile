import 'package:carona_prime/app/models/local_model.dart';
import 'package:carona_prime/app/models/usuario_model.dart';

class GrupoModel {
  String nome;
  List<UsuarioModel> membros;
  List<UsuarioModel> administradores;

  LocalModel partida;
  LocalModel destino;

  Duration horario;

  GrupoModel(this.nome, this.partida, this.destino, this.horario);

  bool domingo;
  bool segunda;
  bool terca;
  bool quarta;
  bool quinta;
  bool sexta;
  bool sabado;
}
