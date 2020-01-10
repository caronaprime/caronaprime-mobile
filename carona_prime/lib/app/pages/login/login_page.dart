import 'package:carona_prime/app/pages/login/login_controller.dart';
import 'package:carona_prime/app/shared/widgets/logo_carona.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LoginPage extends StatelessWidget {
  final controller = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carona Prime')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: LogoCarona(),
          ),
          Expanded(child: SizedBox()),
          Expanded(child: Center(child: Text("Informe seu número de celular"))),
          Expanded(child: SizedBox()),
          phoneTextField(),
          enviarCodigoButton(context),
          labelInformativo(),
          Expanded(child: SizedBox())
        ],
      ),
    );
  }

  code() {
    return Observer(
      builder: (_) => Container(
        child: Text("rever"),
          // child: snapshot.hasData
          //     ? Text(snapshot.data)
          //     : CircularProgressIndicator(),
        )
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
          child: Text("Enviar Código"),
          onPressed: () {
            controller.enviarCodigo(context);
            controller.mostrarDialogoCodigo(context);            
          }),
    );
  }

  phoneTextField() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        onChanged: (value) => controller.setPhoneNumber(value),
        controller: controller.phoneTextController,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: InputDecoration(
          labelText: "Celular",
          hintText: 'Ex: (99) 9 9999 9999 ',
        ),
      ),
    );
  }
}