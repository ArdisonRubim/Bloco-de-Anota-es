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
  Map<String, dynamic> _ultimaAnotacao = Map();

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
    // GERANDO CHAVE ALEATÓRIA PARA EXCLUSAO
    final chave = DateTime.now().microsecondsSinceEpoch.toString();
    return Dismissible(
        key: Key(chave), // Chave aleatória para exclusão ou atualização
        direction: DismissDirection.horizontal,
        background: Container(
          color: Colors.green,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start, // Icon ao final do conteudo
            children: <Widget>[
              Icon(Icons.edit, color: Colors.white,) // Icon
            ],
          ),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end, // Icon ao final do conteudo
            children: <Widget>[
              Icon(Icons.delete, color: Colors.white,) // Icon
            ],
          ),
        ),

        // Removendo anotacao da lista
        onDismissed: (direction){

          if ( direction == DismissDirection.endToStart ) {

            // Deletando Anotacao

            // Recuperar antes de excluir
              _ultimaAnotacao = _listaAnotacoes[index];

              _listaAnotacoes.removeAt(index);
            _salvarAnotacaoConcluida();

            // Desfazendo exclusão
            final alert = SnackBar(
              content: Text("Anotação removida com sucesso!"),
              duration: Duration(seconds: 2),

              action: SnackBarAction(
                  label: "Desfazer",
                  onPressed: () {
                    // Restaurando anotacao
                    setState(() {
                      _listaAnotacoes.insert(index, _ultimaAnotacao);
                    });

                  }
              ),
            );
            // Alert de exclusão
            Scaffold.of(context).showSnackBar(alert);

          }else if ( direction == DismissDirection.startToEnd) {

            _controllerAnotacao.text = _listaAnotacoes[index]["titulo"];
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Atualizar anotação"),
                    content: TextField(
                      controller: _controllerAnotacao,
                      onChanged: (text) {},
                    ),
                    actions: <Widget>[
                      // Botões
                      FlatButton(
                          color: Colors.limeAccent,
                          child: Text(
                            "Confirmar",
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: () {
                            //_listaAnotacoes.insert(index, _controllerAnotacao.text );
                            _salvarAnotacao();
                            _listaAnotacoes.removeAt(index);
                            _salvarAnotacaoConcluida();
                            Navigator.pop(context); // Fechando caixa de diálogo
                          }

                      ),
                    ],
                  );
                });
          }
        },




        child: ListTile(
          title: Text(_listaAnotacoes[index]['titulo']),
        )
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
