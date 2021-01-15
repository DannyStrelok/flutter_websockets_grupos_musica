import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() async {
    print('iniciando...');
    IO.Socket socket = IO.io('http://192.168.1.44:3000',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build()
    );

    socket.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    socket.onDisconnect((_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    socket.on('event', (payload) {
      print('nuevo mensaje');
      print(payload);
    });
    // socket.on('nuevo-mensaje', (payload) {
    //   print('nombre ' + payload['nombre']);
    //     print('mensaje ' + payload['mensaje']);
    // });

    socket.connect();

  }

  ServerStatus get serverStatus => _serverStatus;

}