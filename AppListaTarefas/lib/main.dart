import 'dart:convert';

//import 'dart:html';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];

  Map<String, dynamic> _lastRemovedItem = Map();
  int _lastRemovedPos = 0;

  @override
  void initState() {
    super.initState();
    _getData().then((value) {
      setState(() {
        _toDoList = json.decode(value);
      });
    });
  }

  final todoController = TextEditingController();

  void _addTodo() {
    if (todoController.text != '') {
      setState(() {
        Map<String, dynamic> newTodo = Map();
        newTodo["title"] = todoController.text;
        newTodo["ok"] = false;
        _toDoList.add(newTodo);

        _saveData();

        todoController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de tarefas'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: todoController,
                    decoration: const InputDecoration(
                      labelText: 'Nova Tarefa',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                  onPressed: _addTodo,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10.0),
                  itemCount: _toDoList.length,
                  itemBuilder: _builditem),
            ),
          ),
        ],
      ),
    );
  }

  Widget _builditem(context, index) {
    return Dismissible(
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"].toString()),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          setState(
            () {
              _toDoList[index]["ok"] = c;
              _saveData();
            },
          );
        },
      ),
      onDismissed: (direction) {
        setState(
          () {
            _lastRemovedItem = Map.from(_toDoList[index]);
            _lastRemovedPos = index;
            _toDoList.removeAt(index);

            _saveData();

            final snack = SnackBar(
              content:
                  Text("Tarefa: \"${_lastRemovedItem["title"]}\" removida."),
              action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    _toDoList.insert(_lastRemovedPos, _lastRemovedItem);
                    _saveData();
                  });
                },
              ),
              duration: const Duration(seconds: 2),
            );

            ScaffoldMessenger.of(context).removeCurrentSnackBar();    // ADICIONE ESTE COMANDO
            ScaffoldMessenger.of(context).showSnackBar(snack);
          },
        );
      },
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _toDoList.sort((a, b) {
        if ((a["ok"]) && (!b["ok"])) {
          return 1;
        } else if ((!a["ok"]) && (b["ok"])) {
          return -1;
        } else {
          return 0;
        }
      });
      _saveData();
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);

    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _getData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return '';
    }
  }
}
