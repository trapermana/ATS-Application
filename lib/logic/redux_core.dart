import 'package:databasecrud/logic/actions.dart';
import 'package:databasecrud/models/data_entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

@immutable
class AppState {
  final User firebaseUser;
  final List<PowerEntry> entries;
  final bool hasEntryBeenAdded;
  final DatabaseReference mainReference;

  AppState(
      {this.entries,
      this.hasEntryBeenAdded,
      this.mainReference,
      this.firebaseUser});

  AppState copyWith(
      {List<PowerEntry> entries,
      User firebaseUser,
      DatabaseReference mainReference,
      bool hasEntryBeenAdded}) {
    return new AppState(
        firebaseUser: firebaseUser ?? this.firebaseUser,
        entries: entries ?? this.entries,
        mainReference: mainReference ?? this.mainReference,
        hasEntryBeenAdded: hasEntryBeenAdded ?? this.hasEntryBeenAdded);
  }
}

firebaseMiddleware(Store<AppState> store, action, NextDispatcher next) {
  print(action.runtimeType);
  if(action is InitAction){
    if(store.state.firebaseUser == null){
      FirebaseAuth.instance
              .signInAnonymously()
              .then((user) => store.dispatch(new UserLoadedAction(user)));
      }
    }
     next(action);
      if (action is UserLoadedAction) {
    store.dispatch(new AddDatabaseReferenceAction(FirebaseDatabase.instance
        .reference()
        .child("series")
      ..onChildChanged
          .listen((event) => store.dispatch(new OnChangedAction(event)))
      ..onChildAdded
          .listen((event) => store.dispatch(new OnAddedAction(event)))));
      }
}



AppState reducer(AppState state, action) {
  AppState newState = state;
  if (action is InitAction) {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  } else if (action is AcceptEntryAddedAction) {
    return newState = state.copyWith(hasEntryBeenAdded: false);
  } else if (action is AddEntryAction) {
    return state.copyWith(
        entries: <PowerEntry>[]
          ..addAll(state.entries)
          ..add(action.powerEntry));
  } else if (action is OnAddedAction) {
    newState = _onEntryAdded(state, action.event);
  } else if (action is AddDatabaseReferenceAction) {
    newState = state.copyWith(mainReference: action.databaseReference);
  } else if (action is OnChangedAction) {
    newState = _onEntryEdited(state, action.event);
  }
  return newState;
}

AppState _onEntryAdded(AppState state, Event event) {
  return state.copyWith(
    hasEntryBeenAdded: true,
    entries: <PowerEntry>[]
      ..addAll(state.entries)
      ..add(new PowerEntry.fromSnapshot(event.snapshot))
      ..sort((va1, va2) => va2.dateTime.compareTo(va1.dateTime))
      
  );
}

AppState _onEntryEdited(AppState state, Event event) {
  var oldValue =
      state.entries.singleWhere((entry) => entry.key == event.snapshot.key);
  return state.copyWith(
    entries: <PowerEntry>[]
      ..addAll(state.entries)
      ..[state.entries.indexOf(oldValue)] =
      new PowerEntry.fromSnapshot(event.snapshot)
      ..sort((va1, va2) => va2.dateTime.compareTo(va1.dateTime)),
  );
}