import 'package:flutter/services.dart';
import 'package:timezone/data/latest_all.dart';

import 'package:timezone/timezone.dart';

class TimeHelperService {
  TimeHelperService() {
    setup();
  }
  void setup() async {
    var byteData = await rootBundle.load('assets/2020b.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
    initializeTimeZones();
}
}
Future<DateTime> convertStudentToTut(DateTime stud, TimeZone timeZone) async {  
  return new TZDateTime.from(stud, getLocation(timeZone.toString()));
}


class Tutor {
  final String name;
  final String email;

  const Tutor(this.name, this.email);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tutor && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }
}



class Assignment{
  final String student,subject,comments;
  final int price, amountPaid,id;
  DateTime assigned=DateTime.now(),dueDate = DateTime.now();
  final List<String>  files;

  Assignment(this.student, this.subject, this.comments, this.price, this.amountPaid, this.id, this.files);
  
  @override
  String toString() {
    return student;
  }

}

List<Assignment> assignments = <Assignment>[
  Assignment("abhay", "science", "kamas", 80, 50, 1,  ['abcd','efg']),
  Assignment("abhay", "science", "kamas", 80, 50, 1,  ['abcd','efg']),
  Assignment("abhay", "science", "kamas", 80, 50, 1,  ['abcd','efg']),
  Assignment("abhay", "science", "kamas", 80, 50, 1,  ['abcd','efg']),
  Assignment("abhay", "science", "kamas", 80, 50, 1,  ['abcd','efg']),

];





const contacts = <Tutor>[
  Tutor(
    'Andrew',
    'stock@man.com',
  ),
  Tutor(
    'Paul',
    'paul@google.com',
  ),
  Tutor(
    'Fred',
    'fred@google.com',
  ),
  Tutor(
    'Brian',
    'brian@flutter.io',
  ),
  Tutor(
    'John',
    'john@flutter.io',
  ),
  Tutor(
    'Thomas',
    'thomas@flutter.io',
  ),
  Tutor(
    'Nelly',
    'nelly@flutter.io',
  ),
  Tutor(
    'Marie',
    'marie@flutter.io',
  ),
  Tutor(
    'Charlie',
    'charlie@flutter.io',
  ),
  Tutor(
    'Diana',
    'diana@flutter.io',
  ),
  Tutor(
    'Ernie',
    'ernie@flutter.io',
  ),
  Tutor(
    'Gina',
    'fred@flutter.io',
  ),
];


