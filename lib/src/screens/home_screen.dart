import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_band_names/src/models/band_model.dart';
import 'package:flutter_band_names/src/services/socket_service.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('grupos-activos', this._handleActiveBands);

    super.initState();
  }

  void _handleActiveBands(dynamic payload) {
    setState(() {
      this.bands = (payload as List).map((e) => Band.fromMap(e)).toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('grupos-activos');
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          'Grupos',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue[300],
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          _mostrarGrafico(),
          Expanded(
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (BuildContext context, int index) {
                  return _bandTile(bands[index]);
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Borrar',
              style: TextStyle(color: Colors.white),
            )),
      ),
      onDismissed: (DismissDirection direction) {
        final socketService =
            Provider.of<SocketService>(context, listen: false);
        socketService.socket.emit('delete-band', {'id': band.id});
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text(
          "${band.votes}",
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          print(band.name);
          final socketService =
              Provider.of<SocketService>(context, listen: false);
          socketService.socket.emit('vote-band', {'id': band.id});
        },
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nombre del grupo'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                  child: Text('Añadir'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addBandToList(textController.text))
            ],
          );
        },
      );
    }

    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('Nombre del grupo'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                child: Text('Añadir'),
                isDefaultAction: true,
                onPressed: () => addBandToList(textController.text),
              ),
              CupertinoDialogAction(
                child: Text('Cerrar'),
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  void addBandToList(String name) {
    if (name.length > 0) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _mostrarGrafico() {
    Map<String, double> dataMap = new Map();

    bands.forEach((element) {
      dataMap.putIfAbsent(element.name, () => element.votes.toDouble());
    });

    return Container(
      width: double.infinity,
        height: 200,
        child: PieChart(
            dataMap: dataMap,
          chartValuesOptions: ChartValuesOptions(
            showChartValuesInPercentage: true
          ),
        ));
  }
}
