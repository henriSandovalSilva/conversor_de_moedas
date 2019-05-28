import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request_url = 'https://api.hgbrasil.com/finance?format=json&key=079a988b';

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white
      ),
    ),
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(request_url);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

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
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];

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
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Reais',
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: 'R\$ ',
                        ),
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0,
                        ),
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Reais',
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: 'R\$ ',
                        ),
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0,
                        ),
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Reais',
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: 'R\$ ',
                        ),
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0,
                        ),
                      )
                    ],
                  ),
                );
              }
              break;
            case ConnectionState.waiting:
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
