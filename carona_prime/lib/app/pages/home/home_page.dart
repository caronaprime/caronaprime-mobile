import 'package:carona_prime/app/pages/welcome/welcome_page.dart';
import 'package:carona_prime/app/widgets/default_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LatLng _center = const LatLng(45.521563, -122.677433);

   GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carona Prime')),
      drawer: DefaultDrawer(),
      // bottomNavigationBar: BottomAppBar(
      //     child: Row(
      //   mainAxisSize: MainAxisSize.max,
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: <Widget>[
      //     FlatButton(
      //       child: Text(
      //         'Voltar',
      //         style: TextStyle(
      //           color: Colors.white,
      //           fontSize: 20.0,
      //         ),
      //       ),
      //       onPressed: () {
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => WelcomePage()));
      //       },
      //     ),
      //   ],
      // )),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),

      // body: Center(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: <Widget>[
      //       Text(
      //         "Usuário: \n"
      //         "Numero: \n"
      //         "Status: ",
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
