import 'dart:ffi';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controllerPeso = TextEditingController();
  TextEditingController controllerAltura = TextEditingController();

  String _InfoText = 'Informe seus dados';

  GlobalKey<FormState> _FormKey = GlobalKey<FormState>();

  void _ResetCampos() {
      controllerPeso.text = '';
      controllerAltura.text = '';
      setState(() {
        _InfoText = 'Informe seus dados';
        _FormKey = GlobalKey<FormState>();
      });
  }

  void calculadora_imc() {
    setState(() {
      double peso = double.parse(controllerPeso.text);
      double altura = double.parse(controllerAltura.text);

      if (peso + altura > 0) {
        final double result = peso / (altura * altura);

        String resultArrendodado = result.toStringAsFixed(1);

        if (result < 18.5) {
          _InfoText =
              'IMC ' + resultArrendodado + ' peso muito baixo para a altura';
        } else if ((result >= 18.5) && (result <= 24.9)) {
          _InfoText = 'IMC ' + resultArrendodado + ' peso ideal';
        } else if ((result >= 25) && (result <= 29.9)) {
          _InfoText = 'IMC ' + resultArrendodado + ' Sobrepeso';
        } else if ((result >= 30) && (result < 34.9)) {
          _InfoText = 'IMC ' + resultArrendodado + ' Obesidade grau 1';
        } else if ((result >= 35) && (result < 39.9)) {
          _InfoText = 'IMC ' + resultArrendodado + ' obesidade grau 2 (Severa)';
        } else if (result >= 40) {
          _InfoText =
              'IMC ' + resultArrendodado + ' Obesidade grau 3 (Morbida)';
        }
      } else {
        _InfoText = 'Não foi possivel calcular, insira valores validos';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(onPressed: _ResetCampos, icon: const Icon(Icons.refresh))
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _FormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.person_outline,
                color: Colors.green,
                size: 120,
              ),
              TextFormField(
                validator: (value)
                {
                  if(value!.isEmpty)
                  {
                    return 'Insira seu peso';
                  }
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Peso (KG)',
                  labelStyle: TextStyle(
                    color: Colors.green,
                  ),
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 25,
                ),
                controller: controllerPeso,
              ),
              TextFormField(
                validator: (value)
                {
                  if(value!.isEmpty)
                  {
                    return 'Insira sua altura';
                  }
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Altura(cm)',
                  labelStyle: TextStyle(
                    color: Colors.green,
                  ),
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 25,
                ),
                controller: controllerAltura,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if(_FormKey.currentState!.validate())
                      {
                        calculadora_imc();
                      }
                    },
                    child: const Text(
                      'Calcular',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                  ),
                ),
              ),
              Text(
                _InfoText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 25, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
