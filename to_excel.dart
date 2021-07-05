
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:excel/excel.dart';
import 'dart:async';
import 'globals.dart' as globals;
import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:permission_handler/permission_handler.dart';

void createExcel() async {
  if (await Permission.storage.request().isGranted) {
    var receiptsDictionary = jsonDecode(globals.prefs.getString('receipts'));

    var excel = Excel.createExcel();

    Sheet sheetObject = excel['sheet1'];

    for (int i = 0; i < receiptsDictionary.length; i++) {
      sheetObject.appendRow(['Receipt ${i + 1}']);
      sheetObject.appendRow(
          ['Purchase Date', receiptsDictionary[i]['purchase_date']]);
      sheetObject.appendRow(['Total', receiptsDictionary[i]['total']]);

      receiptsDictionary[i]['items'].forEach((item) {
        var info = [];

        item.forEach((k, v) {
          info.add(v);
        });

        sheetObject.appendRow(info);
      });
    }

    excel.link('MainSheet', sheetObject);

    Directory appDocDir = await DownloadsPathProvider.downloadsDirectory;

    print(appDocDir.path);

    new File('${appDocDir.path}/file.txt').create(recursive: true);

    excel.encode().then((onValue) {
      File("${appDocDir.path}/excel.xlsx")
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });
  }
}