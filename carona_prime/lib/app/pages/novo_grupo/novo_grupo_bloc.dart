import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simple_permissions/simple_permissions.dart';

class NovoGrupoBloc extends BlocBase {
  var _pageIndexController = BehaviorSubject<int>();
  Observable<int> get outPageIndex => _pageIndexController.stream;
  setIndex(int index) => _pageIndexController.sink.add(index);
  var contatosSelecionados = List<Contact>();

  Iterable<Contact> _todosContatos = List<Contact>();
  Iterable<Contact> _contatosFiltrados = List<Contact>();

  var _contatosFiltradosController = BehaviorSubject<Iterable<Contact>>();
  Observable<Iterable<Contact>> get outContatosFiltrados =>
      _contatosFiltradosController.stream;

  void filtrarContatos(String query) {
    if (query.isEmpty) {
      _contatosFiltradosController.sink.add(_todosContatos);
    } else {
      _contatosFiltrados = _todosContatos
          .where((contact) => contact.displayName.toUpperCase().contains(query.toUpperCase()));
      _contatosFiltradosController.sink.add(_contatosFiltrados);
    }
  }

  var _contatosSelecionadosController = BehaviorSubject<List<Contact>>();
  Observable<List<Contact>> get outContatosSelecionados =>
      _contatosSelecionadosController.stream;

  void loadContacts(String query) async {
    try {
      await SimplePermissions.requestPermission(Permission.ReadContacts);
      if (await SimplePermissions.checkPermission(Permission.ReadContacts)) {
        _todosContatos = await ContactsService.getContacts(query: query);
        filtrarContatos(query);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void adicionarContatoSelecionado(Contact contact) {
    contatosSelecionados.add(contact);
    _contatosSelecionadosController.sink.add(contatosSelecionados);
  }

  void removerContatoSelecionado(Contact contact) {
    contatosSelecionados.remove(contact);
    _contatosSelecionadosController.sink.add(contatosSelecionados);
  }

  @override
  void dispose() {
    _pageIndexController.close();
    _contatosSelecionadosController.close();
    _contatosFiltradosController.close();
    super.dispose();
  }
}
