import 'dart:ui';
import 'dart:async';
import 'package:databasecrud/models/data_entry.dart';
import 'package:databasecrud/models/data_streaml.dart';
import 'package:databasecrud/powerlog.dart';

import 'package:databasecrud/text.dart';
import 'package:databasecrud/widget/progresschart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
//import 'package:flutter_signin_button/button_list.dart';

import 'logic/redux_core.dart';

var bgColor = const Color(0xff10375C);
var appColor = const Color(0xff397ab8);
var txColor = const Color(0xffF3C623);

bool modeState = false;
bool chargeState = false;
bool sourceState = false;
bool countDownComplete = true;

String batteryStates;
int _counter;
Timer _timer;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class HomePageModel {
  final List<PowerEntry> entries;
  final double sortedValue;

  HomePageModel({this.entries, this.sortedValue});
}

class _HomeState extends State<Home> {
  DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('DATA');
  DatabaseReference chargeStateRef =
      FirebaseDatabase.instance.reference().child('stateCharge');
  DatabaseReference modeStateRef =
      FirebaseDatabase.instance.reference().child('stateMode');
  DatabaseReference sourceStateRef =
      FirebaseDatabase.instance.reference().child('stateSource');
  DatabaseReference delayStateRef =
      FirebaseDatabase.instance.reference().child('delaySource');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          title: Center(child: Text("Home")),
          leading: Icon(Icons.account_circle_outlined), // color: txColor),
          actions: [
            IconButton(
                icon: Icon(Icons.history),
                onPressed: () => Navigator.of(context).pushNamed('/log'))
          ],
        ),
        body: StreamBuilder(
            stream: dbRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.data.snapshot.value != null) {
                //print("snapshot data: ${snapshot.data.snapshot.value.toString()}");

                var _stream =
                    DATA.fromJson(snapshot.data.snapshot.value['Stream']);
                var _stream2 =
                    DATA.fromJson(snapshot.data.snapshot.value['Usage']);
                batteryStates =
                    '${_stream.persentaseBaterai.toStringAsFixed(0)}';

                //print("Data : ${_stream.arus} / ${_stream.tegangan} / ${_stream.daya} / ${_stream.persentaseBaterai} / ${_stream2.konsumsiDaya}");

                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 60.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CostumText('ATS', 24.0, 3.0),
                              CostumText('Control and Monitoring', 24.0, 3.0),
                              CostumText('Application', 24.0, 0.0)
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Image.asset(
                                'assets/Group.png',
                                width: 80.0,
                                height: 80.0,
                                color: Color.fromRGBO(212, 168, 11, 1),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 35.0,
                      ),
                      Center(
                        child: StoreConnector<AppState, HomePageModel>(
                            converter: (store) {
                          return new HomePageModel(
                            entries: store.state.entries,
                          );
                        }, builder: (contex, viewModel) {
                          return InkWell(
                            onTap: () {
                              _showLogModal(context);
                            },
                            child:
                                Stack(alignment: Alignment.center, children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    color: Colors.blueGrey[900]),
                                height: 220.0,
                                width: 400.0,
                              ),
                              Container(
                                child: ProgressChart(viewModel.entries),
                                height: 200.0,
                                width: 380.0,
                                color: Colors.blueGrey[900],
                              ),
                            ]),
                          );
                        }),
                      ),
                      SizedBox(
                        height: 35.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              CostumText(
                                  "${_stream.tegangan.toStringAsFixed(2)}",
                                  60,
                                  0.0),
                              CostumText('VOLT', 25, 0.0),
                            ],
                          ),
                          Column(
                            children: [
                              CostumText('${_stream.daya.toStringAsFixed(2)}',
                                  60, 0.0),
                              CostumText('WATT', 25, 0.0),
                            ],
                          ),
                          Column(
                            children: [
                              CostumText('${_stream.arus.toStringAsFixed(2)}',
                                  60, 0.0),
                              CostumText('AMPERE', 25, 0.0),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              CostumText(
                                  '${_stream2.konsumsiDaya.toStringAsFixed(2)}',
                                  65,
                                  0.0),
                              CostumText('WATT/HOUR', 25, 0.0),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    Container(
                                        height: 56.0,
                                        width: 178.0,
                                        //color: Colors.black,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[800],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        )),
                                    Positioned(
                                      bottom: 3,
                                      right: barRigthPosition(),
                                      child: Container(
                                        height: 50.0,
                                        width: barWidht(),
                                        //color: _getColor(),
                                        decoration: BoxDecoration(
                                          color: _getColor(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        )
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                        child: CostumText(
                                            _stream.persentaseBaterai
                                                    .toStringAsFixed(0) +
                                                "%",
                                            50,
                                            0.0)),
                                  ]),
                              CostumText('Persentase Baterai', 20.0, 0.0)
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ArgonTimerButton(
                            height: 50,
                            width: 120,
                            minWidth: 120,
                            //highlightColor: Colors.transparent,
                            //highlightElevation: 0,
                            roundLoadingShape: false,
                            onTap: modeState && _counter == 10
                                ? (startTimer, btnState) {
                                    if (btnState == ButtonState.Idle) {
                                      _startTimer();
                                      _sourceState();
                                      setState(() {
                                        sourceState = !sourceState;
                                      });
                                      startTimer(5);
                                    }
                                  }
                                : null,
                            // initialTimer: 10,
                            child: Container(
                              child: Text(
                                sourceState ? "PLN" : "PLTS",
                                style: TextStyle(
                                    color: Color.fromRGBO(244, 246, 255, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            loader: (timeLeft) {
                              return Text(
                                "WAIT | $timeLeft",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              );
                            },
                            borderRadius: 15.0,
                            color: modeState
                                ? Color.fromRGBO(212, 168, 11, 1)
                                : Colors.grey,
                            elevation: 0,
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 1.5),
                          ),
                          ArgonTimerButton(
                            height: 50,
                            width: 120,
                            minWidth: 120,
                            roundLoadingShape: false,
                            onTap: (startTimer, btnState) {
                              if (btnState == ButtonState.Idle) {
                                _startTimer();
                                _modeState();
                                setState(() {
                                  modeState = !modeState;
                                });
                                startTimer(5);
                              }
                            },
                            child: Container(
                              child: Text(
                                modeState ? "MANUAL" : "AUTO",
                                style: TextStyle(
                                  color: Color.fromRGBO(244, 246, 255, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            loader: (timeLeft) {
                              return Text(
                                "WAIT | $timeLeft",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              );
                            },
                            borderRadius: 15.0,
                            color: Color.fromRGBO(212, 168, 11, 1),
                            elevation: 0,
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 1.5),
                          ),
                          ArgonTimerButton(
                            height: 50,
                            width: 120,
                            minWidth: 120,
                            roundLoadingShape: false,
                            onTap: modeState && _counter == 10
                                ? (startTimer, btnState) {
                                    if (btnState == ButtonState.Idle) {
                                      _startTimer();
                                      _chargingState();
                                      setState(() {
                                        chargeState = !chargeState;
                                      });
                                    }
                                    startTimer(5);
                                  }
                                : null,
                            child: Container(
                              child: Text(
                                chargeState ? "CHARGING\nPLN" : "CHARGING\nPV",
                                style: TextStyle(
                                    color: Color.fromRGBO(244, 246, 255, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            loader: (timeLeft) {
                              return Text(
                                "WAIT | $timeLeft",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              );
                            },
                            borderRadius: 15.0,
                            color: modeState
                                ? Color.fromRGBO(212, 168, 11, 1)
                                : Colors.grey,
                            elevation: 0,
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 1.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
                //_display(_stream, _stream2);
              } else {}

              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
  
  double barWidht(){
    int widht = int.parse(batteryStates);

    if (widht == 100) {
      return 170;
    } else if (widht == 75) {
      return  127.5;
    } else if (widht == 50) {
      return  85;
    } else if (widht == 25) {
      return 42.5;
    } else if (widht == 0) {
      return  17;
    }
  }
  double barRigthPosition(){
    int rightPosition = int.parse(batteryStates);

    if (rightPosition == 100) {
      return 0;
    } else if (rightPosition == 75) {
      return 42.5;
    } else if (rightPosition == 50) {
      return 85;
    } else if (rightPosition == 25) {
      return 127.5;
    } else if (rightPosition == 0) {
      return 153;
    }
  }

  Color _getColor() {
    int states = int.parse(batteryStates);
    if (states == 100) {
      return Colors.green[800];
    } else if (states == 75) {
      return Colors.green[400];
    } else if (states == 50) {
      return Colors.orange[400];
    } else if (states == 25) {
      return Colors.orange[900];
    } else if (states == 0) {
      return Colors.red[900];
    }
  }

  void _startTimer() {
    _counter = 10;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
          print(_counter);
        } else {
          _timer.cancel();
          print("complete");
          _counter = 10;
          print(_counter);
        }
      });
    });
  }

  void _chargingState() {
    chargeStateRef.set({'state': chargeState ? '1' : '0'});
  }

  void _sourceState() {
    sourceStateRef.set({'state': sourceState ? '1' : '0'});
  }

  void _modeState() {
    modeStateRef.set({'state': modeState ? '1' : '0'});
  }

  void _showLogModal(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                leading:
                    Icon(Icons.info_outline, color: Colors.white, size: 30),
                backgroundColor: appColor,
                actions: [
                  IconButton(
                      icon: Icon(Icons.cancel),
                      iconSize: 30,
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).pop())
                ],
                expandedHeight: 70.0,
                flexibleSpace: FlexibleSpaceBar(
                    title: Text("Series Details",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Asap',
                        ))),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                PowerLog(),
              ])),
              SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    color: appColor,
                  ))
            ],
          );
        });
  }
}

// Widget _display(DATA _stream, _stream2){
//   return
// }
