import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:tarefas/main.dart';
import 'package:tarefas/repositories/task_repo.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:tarefas/wids/task.dart';
import 'package:tarefas/wids/ListTaskWidget.dart';

import 'package:tarefas/repositories/settings.dart';


class TaskController {

  //começo

  List<TaskModel> tarefas =[];
  List<Text>vazio = [Text("")];
  int get qtdTask => tarefas.length;
  final FocusNode _focusNode = FocusNode();

  //controller para salvar a list

TextEditingController controllerSalveList = TextEditingController();

//controller do texfiled do edit de lista de lista de tarefas
TextEditingController controllerEditListTask = TextEditingController();

//String para dizer o nome da lista

  //instanciando o repositório para armazenagem e reciclagem de dados

  TaskRepo taskrepo = TaskRepo("nulo");

  String? nameList;
  List<String?> ListNameList = [];

  //função usada para desfazer o limpar tudo;

  List<TaskModel> LastTask = [];

//alterar tema

  Future<void> alterarTema() async{
    final isDark = await Settings.getDarkMode();
    themeNotifier.value = isDark? ThemeMode.dark : ThemeMode.light;
  }

  //carregar tema

Future<void> carregarTema() async{
  final isDark = await Settings.getDarkMode();
  themeNotifier.value = isDark? ThemeMode.light : ThemeMode.dark;
  await Settings.setDarkMode(!isDark);
}

  int get qtsPendencia => tarefas.where((tarefa) => !tarefa.concluida).length;

  //variáveis usadas para desfazer a delete
  late TaskModel LastDelete;
  int LastDeletePos = 0;


  bool limpar(){
    if(tarefas.length-qtsPendencia>0) {
      return true;
    }
    else {
      return false;
    }

  }

  bool isDart(){

    if(tarefas.isNotEmpty) print("verificando se é true ${tarefas[0].isDark}");

    return themeNotifier.value == ThemeMode.dark;

  }




}