import 'package:flutter/material.dart';
import 'package:tarefas/main.dart';
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
    return Scaffold(
      appBar:AppBar(
          title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text("$c.nameList")),
          centerTitle: true,
          actions: [ Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(""),
              Row(
                children: [

                  IconButton(

                      onPressed: (){

                        TaskRepo.getList().then((value){
                          c.ListNameList = value;
                        });

                        showDialog(context: context, builder: (context){

                          return StatefulBuilder(
                              builder: (context, setStateDialog){


                                return  AlertDialog(
                                  title: Text("Lista de tarefas: "),
                                  content: Container(
                                    width: MediaQuery.of(context).size.width*0.7,
                                    height: MediaQuery.of(context).size.width*0.5,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: c.ListNameList.length,
                                      itemBuilder: (context, index){
                                        return GestureDetector(

                                          onTap: (){

                                            setState(() {
                                              c.nameList = c.ListNameList[index];
                                              c.taskrepo = TaskRepo(c.nameList);
                                            });

                                            TaskRepo.setLastList(c.ListNameList[index]!).then((value){



                                            });

                                            setState(() {

                                            });
                                            c.taskrepo.getTaskList().then((value){
                                              setState(() {
                                                c.tarefas = value;
                                              });

                                            });
                                            Navigator.pop(context);


                                          },

                                          child: ListTaskWidget(text: c.ListNameList[index]! , onDelete: (){

                                            showDialog(context: context, builder: (context){

                                              return AlertDialog(
                                                content: Container(
                                                  // height: 100,
                                                  //   width: 100,
                                                  child: Text("Deseja realmente excluir a lista de tarefas: \" ${c.ListNameList[index]}\" ? ",
                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                ),
                                                actions: [
                                                  TextButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  }, child: Text("cancelar", style: TextStyle(color:Colors.green))),
                                                  TextButton(onPressed: (){

                                                    Navigator.pop(context);

                                                    TaskRepo.deletarTarefa(c.ListNameList[index]!).then((value){
                                                      setStateDialog((){
                                                        c.ListNameList.removeAt(index);
                                                        setState(() {
                                                          if(c.ListNameList.isNotEmpty) {
                                                            c.nameList = c.ListNameList[0];
                                                            c.tarefas.clear();
                                                            c.taskrepo = TaskRepo(c.nameList);
                                                            c.taskrepo.getTaskList().then((value){
                                                              setState(() {
                                                                c.tarefas = value;
                                                              });

                                                            });

                                                          }
                                                          else {
                                                            c.nameList = "first_task";
                                                            c.tarefas.clear();
                                                            c.taskrepo = TaskRepo(c.nameList);

                                                          }
                                                        });
                                                      });


                                                    });
                                                  }
                                                      , child: Text("sim", style: TextStyle(color: Colors.red),))
                                                ],
                                              );

                                            });





                                            setState(() {

                                            });



                                          },
                                            onEdit: (){
                                              showDialog(context: context, builder: (context){
                                                return AlertDialog(

                                                  content: Container(
                                                    width: 400,
                                                    height: 100,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text("Mudar o nome da tarefa",
                                                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300)),
                                                        TextField(
                                                          controller: c.controllerEditListTask,
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10)
                                                              )
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  actions: [
                                                    TextButton(onPressed: (){
                                                      Navigator.pop(context);
                                                    }, child: Text("Cancelar")),

                                                    TextButton(onPressed: () async {

                                                      Navigator.pop(context);

                                                      await TaskRepo.renameList(c.ListNameList[index]!, c.controllerEditListTask.text);

                                                      setState(() {
                                                        c.nameList = c.controllerEditListTask.text;

                                                        c.ListNameList[index] = c.controllerEditListTask.text;
                                                        c.controllerEditListTask.text = "";
                                                      });



                                                      await TaskRepo.setLastList(c.ListNameList[index]!);

                                                      c.taskrepo = TaskRepo(c.nameList);

                                                      final lista = await c.taskrepo.getTaskList();



                                                      setStateDialog((){

                                                        c.tarefas = lista;
                                                        //   c.ListNameList = await taskrepo

                                                      });

                                                      c.controllerEditListTask.clear();
                                                      setState(() {

                                                      });

                                                    }, child: Text("Salvar"))
                                                  ],

                                                );
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(onPressed: ()
                                    {
                                      setState(() {

                                      });
                                      Navigator.pop(context);
                                    },
                                        child: Text("Cancelar")),

                                    TextButton(onPressed: ()
                                    {
                                      setState(() {

                                      });
                                      Navigator.pop(context);
                                    },
                                        child: Text("Ok"))
                                  ],
                                );
                              }
                          );
                        });

                      }, icon: Icon(Icons.download)),

                  GestureDetector(
                      onTap:(){
                        showDialog(context: context, builder: (context){

                          return StatefulBuilder(

                              builder :  (context, setStateDialog) {
                                return AlertDialog(
                                  title: Text(c.nameList == null
                                      ? "Dê um nome para sua lista de tarefas"
                                      : "Criar nova lista de tarefas"),
                                  content: TextField(
                                    controller: c.controllerSalveList,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text("nome"),
                                    ),
                                  ),
                                  actions: [

                                    //botão de cancelar

                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancelar")),

                                    //Botão de ok
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setStateDialog(()  async{
                                            if (c.nameList == null) {
                                              List<TaskModel> taf = c.tarefas;

                                              c.nameList = c.controllerSalveList.text;
                                              c.taskrepo = TaskRepo(c.nameList);
                                              c.taskrepo.saveTaskList(taf);
                                              TaskRepo.setLastList(c.controllerSalveList.text).then((value){

                                              });


                                            } else {


                                              setState(() {
                                                c.nameList = c.controllerSalveList.text;
                                                c.tarefas.clear();
                                              });

                                              await TaskRepo.setLastList(c.controllerSalveList.text);



                                              if(await TaskRepo.createList(c.nameList!)){
                                                c.taskrepo = TaskRepo(c.nameList);

                                              }
                                            }
                                            final value = await c.taskrepo.getTaskList();

                                            setState(() {
                                              c.tarefas = value;
                                            });

                                            final listK = await TaskRepo.getList();

                                            setState(() {
                                              c.ListNameList = listK;
                                            });




                                            c.controllerSalveList.text = "";
                                          });
                                          // Navigator.of(context).pop();
                                        },
                                        child: Text("Salvar")),
                                  ],

                                );
                              }
                          );

                        });

                      },
                      child: Icon(Icons.save)),
                  SizedBox(width: 20,),
                  c.isDart()?Icon(Icons.bedtime):Icon(Icons.brightness_4),
                ],
              ),

            ],
          )]

      ),
      onDrawerChanged: (context){
        c.focusNode.unfocus();
      },

      drawer: Drawer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Card(

                color: Colors.grey,
                child: SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: 5,),
                      Text("DARK THEME",
                          style: TextStyle(fontSize: 20) ),

                      //icone que muda conforme o thema

                      c.isDart()?Icon(Icons.bedtime):Icon(Icons.brightness_4),

                      Switch(value: themeNotifier.value == ThemeMode.dark,
                          onChanged: (value){
                            c.alterarThema();
                            //themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                            for(int i=0;i<c.tarefas.length;i++){
                              if(c.isDart()){
                                c.tarefas[i].isDark = true;
                              }
                              else {
                                c.tarefas[i].isDark = false;
                              }
                            }
                            c.taskrepo.saveTaskList(c.tarefas);
                            c.focusNode.unfocus();

                          }),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),

      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(" Lista de Tarefas",
                      style:TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,

                      )),
                ),
                SizedBox(height: 20,),

                Center(

                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.89,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5 ,
                            child: TextField(
                              controller: c.controllerNewTask,
                              focusNode: c.focusNode,
                              decoration: InputDecoration(
                                  label: Text("Adicione uma nova tarefa",
                                      style: TextStyle(fontSize: 15)),
                                  border: InputBorder.none
                              ),
                            ),
                          ),

                          ElevatedButton(
                              onPressed:(){
                                TaskModel novaTask = TaskModel(text: c.controllerNewTask.text, isDark: !c.isDart());
                                print("tema: ${novaTask.isDark}");
                                setState(() {
                                  if(c.controllerNewTask.text == "") {
                                    showDialog(
                                        context: context,
                                        builder: (context) {

                                          return AlertDialog(
                                            title: Row(
                                              children: [
                                                Icon(Icons.error, color: Colors.red),
                                                Text('  DÊ UM NOME',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight: FontWeight.w800
                                                    )),
                                              ],
                                            ),
                                            content: Text('Faz-se necessário colocar o nome da tarefa',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                )),
                                            actions: [
                                              TextButton(onPressed: () {
                                                Navigator.of(context).pop();
                                              }, child: Text("OK"),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                  else {
                                    c.tarefas.add(novaTask);
                                    c.taskrepo.saveTaskList(c.tarefas);
                                    print(c.tarefas.length);
                                    c.controllerNewTask.clear();
                                    c.focusNode.unfocus();
                                  }
                                });

                              } ,
                              child: Icon(Icons.add, size: 30, color:Colors.white),
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(15),
                                  backgroundColor: const Color.fromARGB(255, 0, 115, 255)
                              ))
                        ],
                      )),
                ),
                SizedBox(height: 20,),
                Expanded(
                  child: c.tarefas.isEmpty? Center(child: Text("Nenhuma tarefa"))
                      : ListView.builder(
                      itemCount: c.tarefas.length,
                      itemBuilder: (context, index){
                        return Task(
                          model: c.tarefas[index],
                          OnDelete: () {
                            LastDelete = c.tarefas[index];
                            LastDeletePos = index;
                            setState(() {
                              c.tarefas.removeAt(index);
                              c.taskrepo.saveTaskList(c.tarefas);
                            });

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(

                                SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Text("Sua tarefa ${LastDelete.text} foi excluída",
                                        style: TextStyle(
                                          fontSize: 15,
                                        )),
                                    action: SnackBarAction(
                                      backgroundColor: Colors.transparent,
                                      onPressed: (){
                                        setState(() {
                                          c.tarefas.insert(LastDeletePos, LastDelete);
                                          c.taskrepo.saveTaskList(c.tarefas);
                                          // FocusScope.of(context).unfocus();
                                        });

                                      },
                                      label: "DESFAZER",
                                      textColor: c.isDart()?  const Color.fromARGB(255, 26, 5, 254) : const Color.fromARGB(255, 5, 245, 254),

                                    )
                                )

                            );
                          },
                          OnEditing: (){
                            c.taskrepo.saveTaskList(c.tarefas);
                          },
                          OnChaged: (){
                            setState(() {
                              c.taskrepo.saveTaskList(c.tarefas);
                            });
                          },

                        );
                      }
                  ),
                ),
                Center(
                  child: Text("Você possue $qtsPendencia tarefas pendentes",
                    style: TextStyle(fontSize:16,
                        color: qtsPendencia>0?Colors.red:Colors.green),),
                ),
                //SizedBox(width: 40,),
                SizedBox(height: 20,),
                Center(
                  child: ElevatedButton(
                    onPressed: (){

                      showDialog(context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: Row(
                                  children: [
                                    Icon(Icons.warning, color: Colors.amber),
                                    Text(c.tarefas.length==0?"Ta frescando é doido":(c.limpar()?" - Apagar tarefas?":" - Apagar tudo?")),
                                  ],
                                ),
                                content: Text(c.tarefas.length==0?"Tem nada para apagar não abestado" :(c.limpar()?"Deseja realmente apagar todas as tarefas concluídas? Não será possível a recuperação dos dados após serem excluídos.":"Deseja realmente apagar tudo? Não será possível a recuperação dos dados após o delete.")),
                                actions: [
                                  TextButton(child: Text("Cancelar",
                                      style: TextStyle(color: Colors.green)), onPressed: (){
                                    Navigator.of(context).pop();
                                    FocusScope.of(context).requestFocus(FocusNode());
                                  }),
                                  TextButton(child: Text("Apagar",
                                      style: TextStyle(color: Colors.red)),
                                    onPressed: (){
                                      Navigator.of(context).pop();

                                      setState(() {
                                        if(!c.limpar()){
                                          c.tarefas.clear();
                                        }
                                        else {
                                          for(int i=0;i<c.tarefas.length;i++){
                                            if(c.tarefas[i].concluida){
                                              c.LastTask.add(c.tarefas[i]);
                                              c.tarefas.removeAt(i);
                                              i--;
                                            }
                                          }
                                        }

                                        c.taskrepo.saveTaskList(c.tarefas);
                                      });
                                    },)
                                ]
                            );
                          });


                    },
                    child: Text(c.limpar()?"Limpar tarefas concluídas":"Limpar tudo",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal:MediaQuery.of(context).size.width * 0.08 , vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: const Color.fromARGB(255, 255, 179, 0)
                    ),),
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
