import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas/models/task_model.dart';

class TaskRepo{

String? arqList;
static final String arqLastList = "lastList";

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

  static Future<List<String>> getList() async {
    final directory = await getApplicationDocumentsDirectory();
    final customDB = Directory("${directory.path}/taskDir");

     int cont =0;

     List<String> ListItens=[];

    if(await customDB.exists()){
      await for(var entity in customDB.list()){
       if(entity is File) {
         ListItens.add(entity.path.split("/").last.split('.').first);
       }}
      return ListItens;
    }
    else {
      return [];
    }
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

 static Future<void> deletarTarefa(String arquivo) async{
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/taskDir/${arquivo}.json";

    File file = File(path);

    if(await file.exists()) {
     file.delete();
     return;
    }
    else {
      return;
    }
  }

  static Future<bool> createList(String list) async{
    final documents = await getApplicationDocumentsDirectory();
    final file = File("${documents.path}/taskDir/${list}.json");

    if(!await file.exists()){
      await file.create(recursive: true);
      await file.writeAsString("[]");
      return true;

    }
    else {
    return false;
    }

  }

  static Future<void> renameList(String OldName, String NewName) async {
    final directory = await getApplicationDocumentsDirectory();
    File fila = File("${directory.path}/taskDir/$OldName.json");

    if(await fila.exists()){
      fila.rename("${directory.path}/taskDir/$NewName.json");
    }
  }

  // Future<void> _loadData() async{
  //
  //   String data = await _readData();
  //
  //
  // }

static Future<void> setLastList(String lastList) async{
    final shared = await SharedPreferences.getInstance();
    shared.setString(arqLastList, lastList);
}

static Future<String> getLastList() async{
    final shared = await SharedPreferences.getInstance();
    return  shared.getString(arqLastList) ?? "sem arquivo";
}



}