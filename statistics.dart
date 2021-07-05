import 'package:flutter/material.dart';
import 'dart:convert';
import 'globals.dart' as globals;

class StatisticsBuilder extends StatefulWidget {
  @override
  _StatisticsBuilderState createState() => _StatisticsBuilderState();
}

class _StatisticsBuilderState extends State<StatisticsBuilder> {
  @override
  Widget build(BuildContext context) {

    var statisticsDictionary = jsonDecode(globals.prefs.getString('statistics'));

    var vsmonth = statisticsDictionary['this_month_sum'] - statisticsDictionary['average_monthly'];
    var vsmonthColor;
    if (vsmonth.isNegative){
      vsmonthColor = Colors.green;
    }
    else{
      vsmonthColor = Colors.red;
    }

    var vsyear = statisticsDictionary['this_year_sum'] - statisticsDictionary['average_yearly'];
    var vsyearColor;
    if (vsyear.isNegative){
      vsyearColor = Colors.green;
    }
    else {
      vsyearColor = Colors.red;
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Statistics'),),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Average monthly:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 5,),
              Text(
                '${statisticsDictionary['average_monthly']}',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 15,),
              Text(
                'Average yearly:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 5,),
              Text(
                '${statisticsDictionary['average_yearly']}',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 20,),
              Text(
                'This month vs average month:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 5,),
              Text(
                '${vsmonth}',
                style: TextStyle(fontSize: 15,color: vsmonthColor),
              ),
              SizedBox(height: 15,),
              Text(
                'This year vs average year:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 5,),
              Text(
                '${vsyear}',
                style: TextStyle(fontSize: 15,color: vsyearColor),
              ),
              SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
}

/*
Widget statisticsBuilder() {

}
*/
