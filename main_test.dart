import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  var f = File("object_identifiers.csv");
  List<Map<String, Object>> list = [];
  for (var l in f.readAsLinesSync()) {
    var splitted = l.split(',');
    var s = splitted.elementAt(0);
    var splittedInts = s.split('.');
    var asInt = <int>[];
    for (var i in splittedInts) {
      asInt.add(int.parse(i));
    }
    list.add({
      'identifierString': splitted.elementAt(0),
      'readableName': splitted.elementAt(1),
      'identifier': asInt
    });
  }
  print(json.encode(list));
}
