import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaAnotacoes = []; // Criando lista vazia
  TextEditingController _controllerAnotacao = TextEditingController(); // Capturando o que o usuario digitou

  Future<File> _file() async {
    // Definindo local de armazenamento
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/anotacoes.json"); // Definindo local de salvamento
  }

  _salvarAnotacaoConcluida() {
    String anotacaoDigitada = _controllerAnotacao.text;

    // Criando dados da lista
    Map<String, dynamic> anotacao = Map();
    anotacao["titulo"] = anotacaoDigitada;
    setState(() {
      _listaAnotacoes.add(anotacao); // Atualizando lista
    });

    _salvarAnotacao();
    _controllerAnotacao.text = "";
  }

  _salvarAnotacao() async {
    var arquivo = await _file();

    // Salvando arquivo dentro de anotacoes.json
    String dados = json.encode(_listaAnotacoes);
    arquivo.writeAsString(dados);
  }

  _lerAnotacao() async {
    try {
      final arquivo = await _file();
      return arquivo.readAsString();
    } catch (erro) {
      return null;
    }
  }

  Widget criarAnotacao(context, index) {
    return ListTile(
      title: Text(_listaAnotacoes[index]['titulo']),
    );
  }

  // Alteracao antes de carregar o builder
  @override
  void initState() {
    super.initState();
    _lerAnotacao().then((dados) {
      setState(() {
        _listaAnotacoes = json.decode(dados);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.limeAccent,
        title: Text(
          "Bloco de Anotações", // Título
          style: TextStyle(color: Colors.blue),
        ),
      ),

      // Configurando botão adcionar
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.limeAccent,
        foregroundColor: Colors.blue,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Adcionar anotação"),
                  content: TextField(
                    controller: _controllerAnotacao,
                    // Responsável por capturar o que o usuário digitar
                    decoration:
                        InputDecoration(labelText: "Digite sua anotação"),
                    onChanged: (text) {},
                  ),
                  actions: <Widget>[
                    // Botões
                    FlatButton(
                        color: Colors.limeAccent,
                        child: Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Fechando caixa de diálogo
                          _controllerAnotacao.text = "";
                        }

                          ),
                          FlatButton(
                        color: Colors.limeAccent,
                        child: Text(
                          "Salvar",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          _salvarAnotacaoConcluida();
                          Navigator.pop(context); // Fechando
                        })
                  ],
                );
              });
        },
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: _listaAnotacoes.length, itemBuilder: criarAnotacao),
          )
        ],
      ),
    );
  }
}
