import 'dart:io';

void main() {
  var dir = Directory('lib');
  var files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')).toList();
  files.add(File('check_nan.dart'));
  
  int count = 0;
  for (var file in files) {
    if (!file.existsSync()) continue;
    var content = file.readAsStringSync();
    if (content.contains(RegExp(r'\bprint\('))) {
      var newContent = content.replaceAll(RegExp(r'\bprint\('), 'debugPrint(');
      if (!newContent.contains("import 'package:flutter/foundation.dart';") && 
          !newContent.contains("import 'package:flutter/material.dart';")) {
        newContent = "import 'package:flutter/foundation.dart';\n" + newContent;
      }
      file.writeAsStringSync(newContent);
      count++;
    }
  }
  print("Replaced print with debugPrint in $count files.");
}
