import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:qr_scanner/src/providers/db_provider.dart';

class MapaPage extends StatefulWidget {
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {

  final map = MapController();
  String tipoMapa = "streets";

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("cordenadas QR"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              setState(() {
                map.move(scan.getCoordenadas(), 20.0);
              });
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scan){

     return FlutterMap(
       mapController: map,
      options: MapOptions(
        center: scan.getCoordenadas(),
        zoom: 15.0,
      ),
      layers: [
         _crearMapa(),
         _crearMarcadores(scan),
      
      ],
    ); 
  }

  TileLayerOptions _crearMapa(){
    return TileLayerOptions(
          urlTemplate: "https://api.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': 'pk.eyJ1IjoiZWRyaWNrMjciLCJhIjoiY2sxcmE2M2JiMDB5bDNnbXVyNHBxeWVtNCJ9.aNlkBNua_3COTH4LYLvS_w',
            'id': 'mapbox.$tipoMapa',
          },
    );
  }

  MarkerLayerOptions  _crearMarcadores(ScanModel scan){
       return MarkerLayerOptions(
          markers: [
             Marker(
              width: 120.0,
              height: 120.0,
              point:  scan.getCoordenadas(),
              builder: (ctx) =>
               Container(
                child:  Icon(
                  Icons.location_on,
                  size: 70.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        );
  }

  Widget _crearBotonFlotante(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        if(tipoMapa == "streets"){
          tipoMapa = "dark";
        } else if(tipoMapa == "dark"){
          tipoMapa = "outdoors";
        } else if(tipoMapa == "outdoors"){
          tipoMapa = "satellite";
        } else if(tipoMapa == "satellite"){
          tipoMapa = "streets";
        }
        print("$tipoMapa");
        setState(() {});
        // streets, dark, light , outdoors, satellite
      },
    );
  }
}