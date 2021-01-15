import 'package:flutter/material.dart';
import 'package:flutter_band_names/src/services/socket_service.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    // socketService.socket.emit(event)

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(socketService.serverStatus.toString())
            ],
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: (){
          socketService.socket.emit('emitir-mensaje', {
            'nombre': 'Flutterapp',
            'mensaje': 'Hola holita desde flutter'
          } );
        },
      ),
    );
  }

}

