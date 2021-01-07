import 'package:firebase_database/firebase_database.dart';
class PowerEntry {
  String key;
  DateTime dateTime;
  double value;


  PowerEntry(this.dateTime, this.value);
  
  PowerEntry.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        dateTime =
        new DateTime.fromMillisecondsSinceEpoch(snapshot.value["waktu"].toInt()),
        value = snapshot.value["logdaya"];


  toJson() {
    return {
      "logdaya": value,
      "waktu": dateTime.millisecondsSinceEpoch,

    };
  }
}