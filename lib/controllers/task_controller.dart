import 'package:firebase_auth/firebase_auth.dart';
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

  List<TaskModel> tarefas =[]; //substituido
  List<Text>vazio = [Text("")];
  int get qtdTask => tarefas.length;
  final FocusNode focusNode = FocusNode();

  //usuario autenticado

  UserCredential? user = null;

  //

  final userAuth = FirebaseAuth.instance.currentUser;

  //variaveis usadas para desfazer a delete

  late TaskModel? LastDelete;
  int LastDeletePos = 0;

  //controller para salvar a list

TextEditingController controllerSalveList = new TextEditingController();

//controller do texfiled do edit de lista de lista de tarefas
TextEditingController controllerEditListTask = new TextEditingController();

TextEditingController controllerNewTask = new TextEditingController(); //substituido

//String para dizer o nome da lista

  //instanciando o repositório para armazenagem e reciclagem de dados

  TaskRepo taskrepo = TaskRepo("nulo");

  String? nameList; //substituido
  List<String?> ListNameList = []; // substituido

  //função usada para desfazer o limpar tudo;

  List<TaskModel> LastTask = []; //substituido

//alterar tema

  Future<void> alterarThema() async{
    final isDark = await Settings.getDarkMode();
    themeNotifier.value = isDark? ThemeMode.dark : ThemeMode.light;
    await Settings.setDarkMode(!isDark);
  }

  //carregar tema

Future<void> carregarTema() async{
  final isDark = await Settings.getDarkMode();
  themeNotifier.value = isDark? ThemeMode.light : ThemeMode.dark;

}

  int get qtsPendencia => tarefas.where((tarefa) => !tarefa.concluida).length;



// substituido
  bool limpar(){
    if(tarefas.length-qtsPendencia>0) {
      return true;
    }
    else {
      return false;
    }

  }

  //substituido

  bool isDart(){

    if(tarefas.isNotEmpty) print("verificando se é true ${tarefas[0].isDark}");

    return themeNotifier.value == ThemeMode.dark;

  }




}