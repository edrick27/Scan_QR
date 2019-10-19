

import 'dart:async';

import 'package:qr_scanner/src/bloc/validator.dart';
import 'package:qr_scanner/src/providers/db_provider.dart';

class ScansBloc with Validators {
  
  static final ScansBloc _bloc = new ScansBloc._internal();

  factory ScansBloc(){
    return _bloc;
  }

  ScansBloc._internal(){
    obtenetScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();
  
  Stream<List<ScanModel>> get ScanStream     => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get ScanStreamHttp => _scansController.stream.transform(validarHttp);

  dispose(){
    _scansController?.close();
  }

   obtenetScans() async{
    _scansController.sink.add(await DBProvider.db.getAllScans());
  }

  agregarScan(ScanModel nuevoScan) async{
    await DBProvider.db.newScan(nuevoScan);
    obtenetScans();
  }

  borrarScan(int id) async{
    await DBProvider.db.deleteScan(id);
    obtenetScans();
  }

  borrarScanTodos() async{
    await DBProvider.db.deleteAllScan();
    obtenetScans();
  }
}



