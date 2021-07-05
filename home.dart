import 'package:flutter/material.dart';
import 'receipt.dart';
import 'globals.dart' as globals;
import 'dart:convert';

class homeBuilder extends StatefulWidget {
  @override
  _homeBuilderState createState() => _homeBuilderState();
}

class _homeBuilderState extends State<homeBuilder> {

  @override
  Widget build(BuildContext context) {
    var statisticsDictionary = jsonDecode(
        globals.prefs.getString('statistics'));
    var receiptsDictionary = jsonDecode(globals.prefs.getString('receipts'));
    List<Widget> receipts = [];

    var lastReceiptsCount;

    if (receiptsDictionary.length < 3) {
      lastReceiptsCount = receiptsDictionary.length;
    }
    else {
      lastReceiptsCount = 3;
    }


    for (int i = 0; i < 3; i++) {
      var r = Receipt(receiptsDictionary[i], context);
      receipts.add(r.toMiniWidget());
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Welcome ${globals.prefs.getString('first_name')},"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'This month\'s total:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10,),
                Text(
                  '${statisticsDictionary['this_month_sum']}',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 15,),
                Text(
                  'This year\'s total:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10,),
                Text(
                  '${statisticsDictionary['this_year_sum']}',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 15,),
                Text(
                  "Last 3 receipts:",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10,),
                Column(children: receipts,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

