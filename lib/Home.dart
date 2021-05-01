import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _listaAnotacoes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.limeAccent,
        title: Text("Bloco de Anotações",
        style: TextStyle(
          color: Colors.blue
        ),),
      ),

      // Configurando botão adcionar
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.limeAccent,
        foregroundColor: Colors.blue,
        onPressed: (){
          showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text("Adcionar anotação"),
                  content: TextField(
                    decoration: InputDecoration(
                      labelText: "Digite sua anotação"
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      color: Colors.limeAccent,
                      child: Text("Cancelar", style: TextStyle(color: Colors.blue),),
                      onPressed: () => Navigator.pop(context)   // Fechando caixa de dialogo
                    ),
                    FlatButton(
                        color: Colors.limeAccent,
                        child: Text("Salvar", style: TextStyle(color: Colors.blue),),
                        onPressed: () {

                        }
                    )
                  ],
                );
              }
          );
        },
      ),
      
      body: Column(

      ),
    );
  }
}
