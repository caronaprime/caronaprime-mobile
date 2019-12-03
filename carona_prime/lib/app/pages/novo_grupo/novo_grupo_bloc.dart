import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:permission/permission.dart';

class NovoGrupoBloc extends BlocBase {
  var _pageIndexController = BehaviorSubject<int>();
  Observable<int> get outPageIndex => _pageIndexController.stream;
  setIndex(int index) => _pageIndexController.sink.add(index);

  var _contactsController = BehaviorSubject<Iterable<Contact>>();

  Observable<Iterable<Contact>> get outContacts => _contactsController.stream;
  void loadContacts() async {
    var permissionNames = await Permission.requestPermissions([PermissionName.Contacts]);

    // PermissionStatus permissionStatus = await _getPermission();
    // if (permissionStatus == PermissionStatus.granted) {
      var contacts = await ContactsService.getContacts();
      _contactsController.sink.add(contacts);
    // }
  }

  // Future<PermissionStatus> _getPermission() async {
  //   PermissionStatus permission = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.contacts);
  //   if (permission != PermissionStatus.granted &&
  //       permission != PermissionStatus.disabled) {
  //     Map<PermissionGroup, PermissionStatus> permisionStatus =
  //         await PermissionHandler()
  //             .requestPermissions([PermissionGroup.contacts]);
  //     return permisionStatus[PermissionGroup.contacts] ??
  //         PermissionStatus.unknown;
  //   } else {
  //     return permission;
  //   }
  // }

  @override
  void dispose() {
    _pageIndexController.close();
    _contactsController.close();
    super.dispose();
  }
}
