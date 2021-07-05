
import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'receipt_detail.dart';
import 'globals.dart' as globals;

Future<void> fetchReceipts() async {
  final receipts = await http.get(Uri.parse('https://nicolasazzi.pythonanywhere.com/receipts/all/'), headers: {'Authorization': 'Token ${globals.prefs.get('token')}'});
  globals.prefs.setString('receipts', receipts.body);

  final statistics = await http.get(Uri.parse('https://nicolasazzi.pythonanywhere.com/receipts/stats/'), headers: {'Authorization': 'Token ${globals.prefs.get('token')}'});
  globals.prefs.setString('statistics', statistics.body);
}

class Receipt {

  DateTime date;
  double total;
  List<Item> items;
  BuildContext context;

  Receipt(data, BuildContext context){
    this.context = context;
    this.date = DateTime.parse(data['purchase_date'].replaceAll('T',' '));
    this.total = double.parse(data['total']);
    this.items = [];
    try {
      var itemList = data['items'];
      for (int i = 0; i < itemList.length; i++) {
        this.items.add(Item(
            itemList[i]['name'], itemList[i]['quantity'], itemList[i]['price'],
            itemList[i]['unit'], itemList[i]['category']));
      }
    }
    on Error{
      this.items = [];
    }
  }

  List<Widget> firstItems(){

    int l;
    if (items.length >= 3) {
      l = 3;
    }
    else {
      l = items.length;
    }

    List<Widget> w = [];

    for (int i = 0; i < l; i++) {
      w.add(
        Padding(
          padding: EdgeInsets.all(3),
          child: Row(
            children: [
              Text(items[i].name),
              SizedBox(width: 5,),

              Text(items[i].quantity.toString()),
              Text(items[i].unit),
              SizedBox(width: 10,),

              Text((items[i].price * items[i].quantity).toString()),
            ],
          ),
        )
      );
    }

    return w;
  }

  Widget toBigWidget(){

    List<DataRow> itemRows = [];

    for (int i = 0; i < items.length; i++){
      itemRows.add(
        DataRow(
          cells: [
            DataCell(Text(items[i].name)),
            DataCell(Text(items[i].quantity.toString()+items[i].unit)),
            DataCell(Text((items[i].price * items[i].quantity).toString())),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child:  Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date: ${this.date.day}/${this.date.month}/${this.date.year}"),
                SizedBox(height: 3,),
                Text("Total: ${this.total}"),
              ]
            ),
            SizedBox(height: 20,),
            DataTable(
              columns: [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Price')),
              ],
              rows: itemRows,
            )
          ]
        ),
      ),
    );
  }

  Widget toMiniWidget(){
    return Card(
      elevation: 7,
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text("Date: ${this.date.day}/${this.date.month}/${this.date.year}"),
                  SizedBox(height: 3,),
                  Text("Total: ${this.total}"),
                ],
              ),
              Column(
                children: firstItems(),
              ),
            ],
          ),
        ),
        onTap: (){
          Route route = MaterialPageRoute(builder: (context) => ReceiptDetail(this));
          Navigator.push(this.context, route);
          },
      ),
    );
  }
}

class Item {
  int quantity;
  double price;
  String unit, category, name;

  Item(name, quantity, price, unit, category) {
    this.name = name;
    this.quantity = quantity;
    this.price = double.parse(price);
    this.unit = unit;
    this.category = category;
  }
}
