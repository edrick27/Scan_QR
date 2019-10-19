import 'package:flutter/material.dart';

import 'package:qr_scanner/src/pages/direcciones_page.dart';
import 'package:qr_scanner/src/pages/home_page.dart';
import 'package:qr_scanner/src/pages/mapa_page.dart';
import 'package:qr_scanner/src/pages/mapas_page.dart';

Map<String, WidgetBuilder> getRoutes(){

  return <String, WidgetBuilder>{
    '/' : (BuildContext context) => HomePage(),
    'direcciones' : (BuildContext context) => DireccionesPage(),
    'mapas' : (BuildContext context) => MapasPage(),
    'mapa' : (BuildContext context) => MapaPage(),
  };
}