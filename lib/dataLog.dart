import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var bgColor = const Color(0xff10375C);
var txColor = const Color(0xffF3C623);

class DataLog extends StatefulWidget {
  @override
  _DataLogState createState() => _DataLogState();
}

class _DataLogState extends State<DataLog> {
  DatabaseReference dbref = FirebaseDatabase.instance.reference().child("Daya");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            title: Text("Log Konsumsi Daya"),
            actions: [IconButton(icon: Icon(Icons.refresh), onPressed: () {})],
          ),
          body: StreamBuilder(
              stream: dbref.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data.snapshot.value != null) {
                  Map data = snapshot.data.snapshot.value;

                  List list = data.values.toList()
                    ..sort((a, b) => b['waktu'].compareTo(a['waktu']));
                  //print({list.length});

                  // data.forEach(
                  //     (index, data) => item.add({"key": index, ...data}));

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 1.0, color: Colors.white),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                          DateFormat.MMMEd().format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  list[index]['waktu']
                                                      .toInt())),
                                          textScaleFactor: 1.2,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              color: Colors.yellow[700],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0)),
                                      Text(
                                          TimeOfDay.fromDateTime(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      list[index]['waktu']
                                                          .toInt()))
                                              .format(context),
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold))
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                  ),
                                  Text(list[index]['logdaya'].toString(),
                                      textScaleFactor: 1.5,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                      //onTap: () => updateTimeStamp(item[index]['key']),
                      //onLongPress: () => deleteMessage(item[index]['key']),
                    },
                  );
                } else {}

                return Container();
              })),
    );
  }
}

// shape: RoundedRectangleBorder(
//   side: BorderSide(color: txColor, width: 4.0),
//   borderRadius: BorderRadius.circular(15.0),
// ),
// color: Colors.white70,
// child: Column(
//   children: [
//     ListTile(
//       leading: Icon(Icons.label, size: 40),
//       title: Text(DateTime.fromMillisecondsSinceEpoch(
//               list[index]['waktu'].toInt())
//           .toString()),
//       subtitle:
//           Text(list[index]['logdaya'].toString()),
//     )
//   ],
// )
