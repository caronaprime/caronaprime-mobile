import 'package:carona_prime/app/models/notificacao_model.dart';
import 'package:mobx/mobx.dart';
part 'notificacoes_controller.g.dart';

class NotificacoesController = NotificacoesBase with _$NotificacoesController;

abstract class NotificacoesBase with Store {
  @observable
  ObservableList<NotificacaoModel> notificacoes = [
    NotificacaoModel("Patrícia esta te convidando para participar do grupo X", "Origem: Z - Destino: Q"),
    NotificacaoModel("José te adicionou como administrador do grupo Y", "Origem: Z - Destino: Q"),
    NotificacaoModel("Maria quer participar do grupo Z", "Origem: Z - Destino: Q"),
    NotificacaoModel("Maria quer participar do grupo B", "Origem: Z - Destino: Q")

  ].asObservable();
}
