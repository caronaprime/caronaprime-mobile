import 'package:carona_prime/app/pages/inicio/inicio_controller.dart';
import 'package:carona_prime/app/pages/login/login_controller.dart';
import 'package:carona_prime/app/shared/widgets/logo_carona.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LoginPage extends StatelessWidget {
  final PageController pageController;
  final InicioController inicioController;
  LoginPage(this.inicioController, this.pageController);

  final controller = LoginController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final phoneTextController = TextEditingController();
  final nomeTextController = TextEditingController();
  final codeTextController = TextEditingController();

  final FocusNode _nomeFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text('Carona Prime')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: LogoCarona(),
            ),
            nomeTextField(context),
            phoneTextField(context),
            enviarCodigoButton(context),
            labelInformativo(),
          ],
        ),
      ),
    );
  }

  FlatButton labelInformativo() {
    return FlatButton(
      child: Text('Para que servem esses dados?',
          style: TextStyle(color: Colors.black54)),
      onPressed: () {},
    );
  }

  enviarCodigoButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
          child: Text("Enviar Código"), onPressed: () => enviarCodigo(context)),
    );
  }

  void mostrarDialogoCodigo(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Informe o código recebido"),
            content: Observer(
              builder: (_) => TextFormField(
                controller: codeTextController,
                decoration: InputDecoration(errorText: controller.error),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  textTheme: ButtonTextTheme.primary,
                  child: Text("Fechar"),
                  onPressed: () => Navigator.of(context).pop()),
              FlatButton(
                  textTheme: ButtonTextTheme.primary,
                  child: Text("Entrar"),
                  onPressed: () async {
                    await entrar(context);
                  }),
            ],
          );
        });
  }

  nomeTextField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: nomeTextController,
        focusNode: _nomeFocus,
        textInputAction: TextInputAction.next,
        onChanged: controller.setNome,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          labelText: "Nome",
          hintText: 'Ex: João da Silva',
        ),
        onFieldSubmitted: (term) {
          _nomeFocus.unfocus();
          FocusScope.of(context).requestFocus(_phoneFocus);
        },
      ),
    );
  }

  phoneTextField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
          focusNode: _phoneFocus,
          onChanged: (value) => controller.setPhoneNumber(value),
          controller: phoneTextController,
          keyboardType: TextInputType.phone,
          autofocus: false,
          decoration: InputDecoration(
            labelText: "Celular",
            hintText: 'Ex: (99) 9 9999 9999 ',
          ),
          onFieldSubmitted: (term) => enviarCodigo(context)),
    );
  }

  entrar(BuildContext context) async {
    var entrou = await controller.entrar(codeTextController.text);

    if (entrou) {
      while (Navigator.of(context).canPop()) {
        Navigator.pop(context);
      }
    }
  }

  void enviarCodigo(BuildContext context) {
    if (phoneTextController.text.isNotEmpty &&
        nomeTextController.text.isNotEmpty) {
      controller.enviarCodigo(phoneTextController.text);
      mostrarDialogoCodigo(context);
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Favor preencher o nome e número de telefone"),
      ));
    }
  }
}
