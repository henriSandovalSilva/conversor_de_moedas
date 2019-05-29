import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//URL que a requisição será feita
const request_url = 'https://api.hgbrasil.com/finance?format=json&key=079a988b';

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
    ),
  );
}

/*
  ** função que faz a requisição a API
  */
Future<Map> getData() async {
  http.Response response = await http.get(request_url);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //controller das moedas
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  /*
  ** função chamada ao alterar o real
  @param String text recebe o valor digitado no campo
  */
  void _realChanged(String text) {
    //se usuário apagar o valor, remove o valor das outras moedas também
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  /*
  ** função chamada ao alterar o dólar
  @param String text recebe o valor digitado no campo
  */
  void _dolarChanged(String text) {
    //se usuário apagar o valor, remove o valor das outras moedas também
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  /*
  ** função chamada ao alterar o euro
  @param String text recebe o valor digitado no campo
  */
  void _euroChanged(String text) {
    //se usuário apagar o valor, remove o valor das outras moedas também
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  //se usuário apagar o valor de uma moeda, remove o valor das outras moedas também
  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('\$ Conversor \$'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar dados :(',
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  ),
                );
              } else {
                //recupera os dados da API
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];

                //monta da view com os TextField das moedas
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      Divider(),
                      //TextField de reais
                      buildTextField(
                        'Reais',
                        'R\$',
                        realController,
                        _realChanged,
                      ),
                      Divider(),
                      //TextField de dólares
                      buildTextField(
                        'Dólares',
                        'US\$',
                        dolarController,
                        _dolarChanged,
                      ),
                      Divider(),
                      //TextField de euros
                      buildTextField(
                        'Euros',
                        '€ ',
                        euroController,
                        _euroChanged,
                      ),
                    ],
                  ),
                );
              }
              break;
            case ConnectionState.waiting:
              //enquanto está carregando os dados da API
              return Center(
                child: new CircularProgressIndicator(),
              );
              break;
          }
        },
      ),
    );
  }
}

/*
** função para montar os TextField, já que era repetido no código
@param String label recebe o nome do campo
@param String prefix recebe o símbolo da moeda
@param TextEditingController control recebe o controller do TextField
@param Function func recebe a função usada no onChanged do TextField
*/
Widget buildTextField(
    String label, String prefix, TextEditingController control, Function func) {
  //TextField da moedas
  return TextField(
    controller: control,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25.0,
    ),
    //chama a função que faz os cálculos de conversão
    onChanged: func,
    //abre o teclado no números
    keyboardType: TextInputType.number,
    //permite apenas número
    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
  );
}
