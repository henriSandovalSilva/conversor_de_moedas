import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request_url = 'https://api.hgbrasil.com/finance?format=json&key=079a988b';

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('\$ Conversor \$'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
    );
  }
}

