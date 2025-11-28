import 'package:flutter/material.dart';
import 'package:tarefas/main.dart';
import 'package:tarefas/pages/stateMobile/celDeltado_page.dart';
import 'package:tarefas/pages/stateMobile/celPe_page.dart';
import 'package:tarefas/repositories/task_repo.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:tarefas/wids/task.dart';
import 'package:tarefas/wids/ListTaskWidget.dart';

import 'package:tarefas/repositories/settings.dart';
import 'package:tarefas/controllers/task_controller.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  //começo

  TaskController c = TaskController();


  @override
  void initState(){
    super.initState();
    c.carregarTema();
    TaskRepo.getList().then(
            (value){
          c.ListNameList = value;
          if(c.ListNameList.isNotEmpty){
            TaskRepo.getLastList().then((value){
              setState(() {
                c.nameList = value;
                c.taskrepo = TaskRepo(c.nameList ?? "nulo");
              });

              c.taskrepo.getTaskList().then(
                      (value){
                    setState(() {
                      c.tarefas = value;

                      // if(tarefas.length>0){
                      //   if(tarefas[0].isDark){
                      //     themeNotifier.value = ThemeMode.dark;
                      //   }
                      // }


                    });

                  }
              );

            });

          }
          else {
            TaskRepo.getLastList().then((value){
              setState(() {
                c.nameList = value;
                c.taskrepo = TaskRepo(c.nameList ?? "nulo");

                c.taskrepo.getTaskList().then(
                        (value){
                      setState(() {
                        c.tarefas = value;

                        // if(tarefas.length>0){
                        //   if(tarefas[0].isDark){
                        //     themeNotifier.value = ThemeMode.dark;
                        //   }
                        // }


                      });

                    }
                );
              });
            });
          }


        }
    );


    //carregar o tema que o usuário escolheu




    //carregar as tarefas antigas



    if(c.tarefas.isNotEmpty) print("verificando se é true: ${c.tarefas[0].isDark}");
    if(c.tarefas.isEmpty) print("ta vazio");


  }








  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(

        builder: (BuildContext context, Orientation orientation) {

          return orientation == Orientation.portrait ?
              CelpePage(c: c) : CelDeitadoPage(c: c);

        }

    );
  }

  }