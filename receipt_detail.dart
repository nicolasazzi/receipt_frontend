
import 'package:flutter/material.dart';
import 'receipt.dart';

//ignore: must_be_immutable
class ReceiptDetail extends StatefulWidget {
  Receipt r;

  ReceiptDetail(r){
    this.r = r;
  }

  @override
  _ReceiptDetailState createState() => _ReceiptDetailState();
}

class _ReceiptDetailState extends State<ReceiptDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Receipt detail'),
      ),
      body: widget.r.toBigWidget()
    );
  }
}
