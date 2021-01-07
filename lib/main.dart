import 'dart:ui';

import 'package:databasecrud/SignInForm.dart';
import 'package:databasecrud/dataLog.dart';
import 'package:databasecrud/homepage.dart';
import 'package:databasecrud/logic/actions.dart';
// import 'package:databasecrud/powerlog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:databasecrud/logic/redux_core.dart';



var bgColor = const Color(0xff10375C);
var txColor = const Color(0xffF3C623);
var appColor = const Color(0xff397ab8);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final Store<AppState> _store = new Store(reducer,
      initialState: new AppState(
        entries: new List(),
        hasEntryBeenAdded: false),
      middleware: [firebaseMiddleware].toList());
  runApp(MyApp(store:_store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  MyApp({this.store});
  @override
  Widget build(BuildContext context) {
    store.dispatch(new InitAction());
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => FrontPage(),
          '/home': (context) => Home(),
          '/log': (context) => DataLog()//PowerLog()
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
