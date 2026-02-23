import 'dart:io';

void main() {
  final dir = Directory('lib/app/features');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('_view.dart'));
  final regex = RegExp(r'\s*onItemSelected\s*:\s*\([^)]*\)\s*\{[^}]*\},', multiLine: true, dotAll: true);
  
  for (var file in files) {
    if (file.path.contains('settings_view')) continue;
    var content = file.readAsStringSync();
    if (content.contains('onItemSelected:')) {
      content = content.replaceAll(regex, '');
      file.writeAsStringSync(content);
      print('Updated ${file.path}');
    }
  }
}
