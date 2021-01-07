import 'package:databasecrud/models/data_entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AddDatabaseReferenceAction {
  final DatabaseReference databaseReference;

  AddDatabaseReferenceAction(this.databaseReference);
}

class AddEntryAction {
  final PowerEntry powerEntry;
  AddEntryAction(this.powerEntry);
}

class EditEntryAction {
  final PowerEntry weightEntry;

  EditEntryAction(this.weightEntry);
}

class OnChangedAction {
  final Event event;

  OnChangedAction(this.event);
}

class OnAddedAction {
  final Event event;

  OnAddedAction(this.event);
}

class UserLoadedAction {
  final UserCredential user;
  UserLoadedAction(this.user);
}

class AcceptEntryAddedAction {}

class InitAction {}
