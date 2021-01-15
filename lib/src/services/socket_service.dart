import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}



class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;
  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() async {
    print('iniciando...');
    this._socket = IO.io('http://192.168.1.44:3000',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build()
    );

    this._socket.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.onDisconnect((_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    this._socket.on('event', (payload) {
      print('nuevo mensaje');
      print(payload);
    });
    // socket.on('nuevo-mensaje', (payload) {
    //   print('nombre ' + payload['nombre']);
    //     print('mensaje ' + payload['mensaje']);
    // });

    this._socket.connect();

  }



}