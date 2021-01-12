import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_band_names/src/models/band_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    Band(id: '1', name: 'Slipknot', votes: 4),
    Band(id: '2', name: 'The Black Keys', votes: 4),
    Band(id: '3', name: 'Cannibal Corpse', votes: 4),
    Band(id: '4', name: 'Los manolos', votes: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'Grupos',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (BuildContext context, int index) {
            return _bandTile(bands[index]);
          }),
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
      background: Container(color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Align(
          alignment: Alignment.centerLeft,
            child: Text('Borrar', style: TextStyle(color: Colors.white),)),
      ),
      onDismissed: (DismissDirection direction) {
        print(direction.toString());
        // borrar elemento en el servidor
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
        },
      ),
    );
  }

  addNewBand() {

    final textController = new TextEditingController();

    if( Platform.isAndroid ) {
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
                  onPressed: () => addBandToList(textController.text)
              )
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
        }
    );


  }
  
  void addBandToList( String name ){
    if(name.length > 0) {
      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
  
}
