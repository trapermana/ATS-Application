import 'package:databasecrud/datalist.dart';
import 'package:databasecrud/logic/actions.dart';
import 'package:databasecrud/logic/redux_core.dart';
import 'package:databasecrud/models/data_entry.dart';

// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PowerLog extends StatefulWidget {
  @override
  _PowerLogState createState() => _PowerLogState();
}

var bgColor = const Color(0xff10375C);
var appColor = const Color(0xff397ab8);
//final mainReference = FirebaseDatabase.instance.reference().child('Daya');

@immutable
class PowerLogModel {
  final List<PowerEntry> entries;
  final bool hasEntryBeenAdded;

  final Function() acceptEntryAddedCallback;
  final Function(PowerEntry) addEntryCallback;

  PowerLogModel(
      {this.entries,
      this.hasEntryBeenAdded,
      this.acceptEntryAddedCallback,
      this.addEntryCallback});
}

class _PowerLogState extends State<PowerLog> {
  //List<PowerEntry> powerSaves = new List();
  ScrollController _listViewScrollController = new ScrollController();
  //double _itemExtent = 50.0;

  // _PowerLogState() {
  //   mainReference.onChildAdded.listen(_onEntryAdded);
  // }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PowerLogModel>(converter: (store) {
      return new PowerLogModel(
        
        hasEntryBeenAdded: store.state.hasEntryBeenAdded,
        addEntryCallback: ((entry) =>
            store.dispatch(new AddEntryAction(entry))),
        entries: store.state.entries,
        acceptEntryAddedCallback: (() =>
            store.dispatch(new AcceptEntryAddedAction())),
      );
    }, builder: (context, viewModel) {
      if (viewModel.hasEntryBeenAdded) {
        _scrollToTop();
        viewModel.acceptEntryAddedCallback();
      }
      return Container(
        color: Colors.white70,
          // appBar: AppBar(
          //   backgroundColor: bgColor,
          //   title: new Text('Data Logs'),
          // ),
          child: ListView.builder(
            shrinkWrap: true,
            // reverse: true,
            controller: _listViewScrollController,
            itemCount: viewModel.entries.length,
            itemBuilder: (buildContext, index) {
              return InkWell(
                child: Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        width: 1,
                        color: Colors.white
                      )),
                      color: appColor,
                    ),
                    child: DataList(viewModel.entries[index])),
              );
            },
          ));
    });
  }
  _scrollToTop() {
    if (_listViewScrollController.hasClients) {
      _listViewScrollController.animateTo(
        0.0,
        duration: const Duration(microseconds: 1),
        curve: new ElasticInCurve(0.01),
      );
    } else {
      print("no Client");
    }
  }
  // _onEntryAdded(Event event) {
  //   setState(() {
  //     powerSaves.add(new PowerEntry.fromSnapshot(event.snapshot));
  //     powerSaves.sort((we1, we2) => we1.dateTime.compareTo(we2.dateTime));
  //   });
  //   _scrollToTop();
  // }
}
