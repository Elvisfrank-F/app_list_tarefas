import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas/task_model.dart';

class TaskRepo{

String? arqList;

  TaskRepo(String? a) {
    this.arqList = a;
  }



 // late SharedPreferences sharedPreferences;

  Future<List<TaskModel>> getTaskList() async{
    //sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString =  await _readData();
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => TaskModel.fromJson(e)).toList();
  }

  void saveTaskList(List<TaskModel> tarefas) {
    _saveData(tarefas);
  }

  Future<File> _getFile() async{

    final directory = await getApplicationDocumentsDirectory();
    final customDB = Directory("${directory.path}/taskDir");

    if(!await customDB.exists()){
      customDB.create(recursive: true);
    }

    return File("${customDB.path}/${arqList ?? "nulo"}.json");

  }

  Future<File> _saveData(List<TaskModel> save) async {
     String data = json.encode(save);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async{
    try{
      final file = await _getFile();

      if(await file.exists()) {
        return file.readAsString();
      }
      else {
        return "[]";
      }
    }
    catch(e) {
      return "[]";
    }
  }

  Future<void> deletarTarefa() async{
    final directory = await _getFile();
    final path = "${directory.path}/taskDir/$arqList";

    File file = File(path);

    if(await file.exists()) {
     file.delete();
     return;
    }
    else {
      return;
    }
  }

  // Future<void> _loadData() async{
  //
  //   String data = await _readData();
  //
  //
  // }



}