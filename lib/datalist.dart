import 'dart:ui';

import 'package:databasecrud/models/data_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DataList extends StatelessWidget {
  final PowerEntry powerEntry;

  DataList(this.powerEntry);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Column(
                children: [
                  new Text(
                    new DateFormat.MMMEd().format(powerEntry.dateTime),
                    textScaleFactor: 0.9,
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      color: Colors.yellow[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0
                    )
                  ),
                  new Text(
                    new TimeOfDay.fromDateTime(powerEntry.dateTime).format(context),
                    textScaleFactor: 0.8,
                    textAlign: TextAlign.right,
                    style: new TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
              ),
              Text(
                powerEntry.value.toString(),
                textScaleFactor: 1.5,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ]));
  }
}
