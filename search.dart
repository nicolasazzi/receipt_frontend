import 'dart:convert';

import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'receipt.dart';

class SearchBuilder extends StatefulWidget {
  @override
  _SearchBuilderState createState() => _SearchBuilderState();
}

class _SearchBuilderState extends State<SearchBuilder> {

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {

    var receiptsDictionary = jsonDecode(globals.prefs.getString('receipts'));
    List<Widget> receipts = [];
    for (int i = 0; i < receiptsDictionary.length; i++){
      var r = Receipt(receiptsDictionary[i], context);
      receipts.add(r.toMiniWidget());
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: !isSearching ? Text('Search') :
          TextField(
            decoration: InputDecoration(
                hintText: 'Search for receipts...',
                hintStyle: TextStyle(color: Colors.white
                )
            ),
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            onChanged: (value) {},
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: (){
                  setState(() {
                    this.isSearching = !this.isSearching;
                  });
                }
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: receipts.length,
              itemBuilder: (BuildContext context, int index) {
                return receipts[index];
              }
          ),
        ),
      ),
    );
  }
}
