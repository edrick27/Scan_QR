import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_scanner/src/bloc/scans_bloc.dart';
import 'package:qr_scanner/src/models/scan_model.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qr_scanner/src/utils/utils.dart' as util;

import 'package:qr_scanner/src/pages/direcciones_page.dart';
import 'package:qr_scanner/src/pages/mapas_page.dart';


class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scanBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scanBloc.borrarScanTodos,
          )
        ],
      ),
      body: _callPages(currentIndex),
      bottomNavigationBar: _crearBottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: _scanQR,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _crearBottomBar() {
    
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text("Mapas")
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text("Direcciones")
        ),
      ],
    );
  }

  Widget _callPages(int currentPage){
    switch (currentPage) {
      case 0: return MapasPage();
      case 1: return DireccionesPage();

      default:
        return MapasPage();
    }
  }

  _scanQR() async {
    // geo:40.724233047051705,-74.00731459101564
    // http://fernando-herrera.com
    String futureString = 'http://fernando-herrera.com';

    try {
      futureString = await new QRCodeReader().scan();
    } catch (e) {
       futureString = e.toString();
    }

    if (futureString != null) {
      final nuevoScan = ScanModel(valor: futureString);
      scanBloc.agregarScan(nuevoScan);

      if(Platform.isIOS){
        Future.delayed(Duration(microseconds: 750),(){
          util.abrirScan(nuevoScan, context);
        });
      } else {
        util.abrirScan(nuevoScan, context);
      }
      // DBProvider.db.newScan(nuevoScan);
    }
  }
}
