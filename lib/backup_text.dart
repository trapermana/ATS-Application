// final value = snapshot.data.snapshot.value as Map;
//                 for (final key in value.keys) {
//                   print(value[key]);
//                 }
//                 Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
//                 List<dynamic> list = map.values.toList()..sort((a, b) => b['waktu'].compareTo(a['waktu']));
//                 print("/n");
//                 print(list);
// //SORTING LIST DARI SNAPSHOT.

// @override
  // void initState() {
  //   DatabaseReference dbref = FirebaseDatabase.instance.reference();
  //   dbref.child('Daya').orderByChild('waktu').once().then((DataSnapshot snap){
  //     var keys =  snap.value.keys;
  //     var data = snap.value;
  //     allData.clear();
  //     for(var key in keys){
  //       myData d = new myData(
  //         data[key]['logdaya'],
  //         data[key]['waktu']);
  //       allData.add(d);
  //     }
  //     setState(() {
  //       print('Length : ${allData.length}');
  //     });
//READ DATA TO LIST

/*
ArgonTimerButton(
                            height: 50,
                            width: 120,
                            minWidth: 120,
                            //highlightColor: Colors.transparent,
                            //highlightElevation: 0,
                            roundLoadingShape: false,
                            onTap: modeState ? (startTimer, btnState) {
                              if (btnState == ButtonState.Idle) {
                                _sourceState();
                                setState(() {
                                  sourceState = !sourceState;
                                });
                                startTimer(5);
                              }
                            }: null,
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
                            color: modeState ? Color.fromRGBO(212, 168, 11, 1) : Colors.grey,
                            elevation: 0,
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 1.5),
                          ),

*/
/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:screens/SecondScreen';                                               
class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
}
class SplashState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initScreen(context),
    );
  }
  
  startTime() async {
    var duration = new Duration(seconds: 6);
    return new Timer(duration, route);
  }
route() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => SecondScreen()
      )
    ); 
  }
  
  initScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset("images/logo.png"),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text(
              "Splash Screen",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 1,
           )
         ],
       ),
      ),
    );
  }
}*/