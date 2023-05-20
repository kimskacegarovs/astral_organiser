import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

Future<String> localPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> localFile(String fileName) async {
  final path = await localPath();
  return File('$path/$fileName');
}

class Repository<T> {
  final String fileName;

  Repository(this.fileName);

  Future<List<T>> readData(T Function(Map<String, dynamic>) fromMap) async {
    final file = await localFile(fileName);
    if (!file.existsSync()) {
      file.createSync();
      file.writeAsString("[]");
    }

    final contents = await file.readAsString();
    final List<dynamic> dataList = jsonDecode(contents);
    final List<T> data = dataList.map((e) => fromMap(jsonDecode(e))).toList();
    return data;
  }

  Future<File> writeData(List<T> data) async {
    final file = await localFile(fileName);
    return file.writeAsString(jsonEncode(data));
  }

  Future<File> deleteData(List<T> data) async {
    return writeData(data);
  }
}
