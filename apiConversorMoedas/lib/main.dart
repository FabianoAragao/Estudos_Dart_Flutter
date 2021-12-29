import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=b935c83f';

void main() async {
  runApp(
    MaterialApp(
      home: const Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        ),
      ),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final euroController = TextEditingController();
  final dollarController = TextEditingController();
  final btcController = TextEditingController();

  double euro = 0.00;
  double dolar = 0.00;
  double bitcoin = 0.00;

  void _clearAll() {
    realController.text = "";
    dollarController.text = "";
    euroController.text = "";
    btcController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double reais = double.parse(text);

    euroController.text = (reais / euro).toStringAsFixed(2);
    dollarController.text = (reais / dolar).toStringAsFixed(2);
    btcController.text = (reais / bitcoin).toStringAsFixed(2);
  }

  void _dollarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);

    euroController.text = ((dolar * this.dolar) / euro).toStringAsFixed(2);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    btcController.text = ((dolar * this.dolar) / bitcoin).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);

    dollarController.text = ((euro * this.euro) / dolar).toStringAsFixed(2);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    btcController.text = ((euro * this.euro) / bitcoin).toStringAsFixed(2);
  }

  void _btcChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double bitcoin = double.parse(text);

    euroController.text = ((bitcoin * this.bitcoin) / euro).toStringAsFixed(2);
    realController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
    dollarController.text =
        ((bitcoin * this.bitcoin) / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('\$ Conversor \$'),
        backgroundColor: Colors.amber,
        actions: <Widget>[
          IconButton(
            onPressed: _clearAll,
            icon: const Icon(
              Icons.refresh,
              color: Colors.green,
              size: 30.0,
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  'Carregando...',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.amber,
                  ),
                ),
              );

            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Erro ao carregar dados.',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.amber,
                    ),
                  ),
                );
              } else {
                dolar = snapshot.data?["results"]["currencies"]["USD"]["buy"];
                bitcoin = snapshot.data?["results"]["currencies"]["BTC"]["buy"];
                euro = snapshot.data?["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      const Divider(),
                      buildTextField(
                          'Reais', 'R\$: ', realController, _realChanged),
                      const Divider(),
                      buildTextField('Dólares', 'U\$\$: ', dollarController,
                          _dollarChanged),
                      const Divider(),
                      buildTextField(
                          'Euros', '€: ', euroController, _euroChanged),
                      const Divider(),
                      buildTextField(
                          'Bitcoin', '₿: ', btcController, _btcChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

Widget buildTextField(String label, prefix,
    TextEditingController moedaController, Function(String value) func) {
  return TextField(
    controller: moedaController,
    keyboardType: TextInputType.number,
    onChanged: func,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.amber),
        border: const OutlineInputBorder(),
        prefixText: prefix,
        prefixStyle: const TextStyle(color: Colors.amber, fontSize: 25.0)),
    style: const TextStyle(
      color: Colors.amber,
      fontSize: 25.0,
    ),
  );
}
