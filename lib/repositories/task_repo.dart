import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas/task_model.dart';

class TaskRepo{

  TaskRepo(){
    SharedPreferences.getInstance().then(
      (value)=> sharedPreferences = value
    );
  }

  late SharedPreferences sharedPreferences;

  Future<List<TaskModel>> getTaskList() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString('task_list') ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => TaskModel.fromJson(e)).toList();
  }

  void saveTaskList(List<TaskModel> tarefas) {
    final String jsonString = json.encode(tarefas);
    print(jsonString);
    sharedPreferences.setString('task_list', jsonString);
  }

}