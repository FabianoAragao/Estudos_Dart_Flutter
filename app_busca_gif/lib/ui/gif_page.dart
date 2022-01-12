import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_gifData["title"]),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                Share.share(_gifData["images"]["fixed_height"]["url"]);
              },
              icon: const Icon(Icons.share))
        ],
      ),
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
