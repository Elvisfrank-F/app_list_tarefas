import 'package:flutter/material.dart';
import 'package:tarefas/pages/home_page.dart';
import 'package:tarefas/controllers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:tarefas/main.dart';
import 'package:tarefas/repositories/task_repo.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:tarefas/wids/task.dart';
import 'package:tarefas/wids/ListTaskWidget.dart';

import 'package:tarefas/repositories/settings.dart';
import 'package:tarefas/controllers/task_controller.dart';



class CelDeitadoPage extends StatefulWidget {

  final TaskController c;
  const CelDeitadoPage({super.key, required this.c});

  @override
  State<CelDeitadoPage> createState() => _CelDeitadoPageState();
}

class _CelDeitadoPageState extends State<CelDeitadoPage> {



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
          title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text("${widget.c.nameList}")),
          centerTitle: true,
          actions: [ Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(""),
              Row(
                children: [

                  IconButton(

                      onPressed: (){

                        TaskRepo.getList().then((value){
                          widget.c.ListNameList = value;
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
                                      itemCount: widget.c.ListNameList.length,
                                      itemBuilder: (context, index){
                                        return GestureDetector(

                                          onTap: (){

                                            setState(() {
                                              widget.c.nameList = widget.c.ListNameList[index];
                                              widget.c.taskrepo = TaskRepo(widget.c.nameList);
                                            });

                                            TaskRepo.setLastList(widget.c.ListNameList[index]!).then((value){



                                            });

                                            setState(() {

                                            });
                                            widget.c.taskrepo.getTaskList().then((value){
                                              setState(() {
                                                widget.c.tarefas = value;
                                              });

                                            });
                                            Navigator.pop(context);


                                          },

                                          child: ListTaskWidget(text: widget.c.ListNameList[index]! , onDelete: (){

                                            showDialog(context: context, builder: (context){

                                              return AlertDialog(
                                                content: Container(
                                                  // height: 100,
                                                  //   width: 100,
                                                  child: Text("Deseja realmente excluir a lista de tarefas: \" ${widget.c.ListNameList[index]}\" ? ",
                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                ),
                                                actions: [
                                                  TextButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  }, child: Text("cancelar", style: TextStyle(color:Colors.green))),
                                                  TextButton(onPressed: (){

                                                    Navigator.pop(context);

                                                    TaskRepo.deletarTarefa(widget.c.ListNameList[index]!).then((value){
                                                      setStateDialog((){
                                                        widget.c.ListNameList.removeAt(index);
                                                        setState(() {
                                                          if(widget.c.ListNameList.isNotEmpty) {
                                                            widget.c.nameList = widget.c.ListNameList[0];
                                                            widget.c.tarefas.clear();
                                                            widget.c.taskrepo = TaskRepo(widget.c.nameList);
                                                            widget.c.taskrepo.getTaskList().then((value){
                                                              setState(() {
                                                                widget.c.tarefas = value;
                                                              });

                                                            });

                                                          }
                                                          else {
                                                            widget.c.nameList = "first_task";
                                                            widget.c.tarefas.clear();
                                                            widget.c.taskrepo = TaskRepo(widget.c.nameList);

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
                                                    //  mainAxisAlignment: MainAxisAlignment.center,
                                                     // crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text("Mudar o nome da tarefa",
                                                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300)),
                                                        TextField(
                                                          controller: widget.c.controllerEditListTask,
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

                                                      await TaskRepo.renameList(widget.c.ListNameList[index]!, widget.c.controllerEditListTask.text);

                                                      setState(() {
                                                        widget.c.nameList = widget.c.controllerEditListTask.text;

                                                        widget.c.ListNameList[index] = widget.c.controllerEditListTask.text;
                                                        widget.c.controllerEditListTask.text = "";
                                                      });



                                                      await TaskRepo.setLastList(widget.c.ListNameList[index]!);

                                                      widget.c.taskrepo = TaskRepo(widget.c.nameList);

                                                      final lista = await widget.c.taskrepo.getTaskList();



                                                      setStateDialog((){

                                                        widget.c.tarefas = lista;
                                                        //   widget.c.ListNameList = await taskrepo

                                                      });

                                                      widget.c.controllerEditListTask.clear();
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
                                  title: Text(widget.c.nameList == null
                                      ? "Dê um nome para sua lista de tarefas"
                                      : "Criar nova lista de tarefas"),
                                  content: TextField(
                                    controller: widget.c.controllerSalveList,
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
                                            if (widget.c.nameList == null) {
                                              List<TaskModel> taf = widget.c.tarefas;

                                              widget.c.nameList = widget.c.controllerSalveList.text;
                                              widget.c.taskrepo = TaskRepo(widget.c.nameList);
                                              widget.c.taskrepo.saveTaskList(taf);
                                              TaskRepo.setLastList(widget.c.controllerSalveList.text).then((value){

                                              });


                                            } else {


                                              setState(() {
                                                widget.c.nameList = widget.c.controllerSalveList.text;
                                                widget.c.tarefas.clear();
                                              });

                                              await TaskRepo.setLastList(widget.c.controllerSalveList.text);



                                              if(await TaskRepo.createList(widget.c.nameList!)){
                                                widget.c.taskrepo = TaskRepo(widget.c.nameList);

                                              }
                                            }
                                            final value = await widget.c.taskrepo.getTaskList();

                                            setState(() {
                                              widget.c.tarefas = value;
                                            });

                                            final listK = await TaskRepo.getList();

                                            setState(() {
                                              widget.c.ListNameList = listK;
                                            });




                                            widget.c.controllerSalveList.text = "";
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
                  widget.c.isDart()?Icon(Icons.bedtime):Icon(Icons.brightness_4),
                ],
              ),

            ],
          )]

      ),
      onDrawerChanged: (context){
        widget.c.focusNode.unfocus();
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

                      widget.c.isDart()?Icon(Icons.bedtime):Icon(Icons.brightness_4),

                      Switch(value: themeNotifier.value == ThemeMode.dark,
                          onChanged: (value){
                            widget.c.alterarThema();
                            //themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                            for(int i=0;i<widget.c.tarefas.length;i++){
                              if(widget.c.isDart()){
                                widget.c.tarefas[i].isDark = true;
                              }
                              else {
                                widget.c.tarefas[i].isDark = false;
                              }
                            }
                            widget.c.taskrepo.saveTaskList(widget.c.tarefas);
                            widget.c.focusNode.unfocus();

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
            padding: MediaQuery.of(context).size.height > 400? EdgeInsets.all(10): EdgeInsets.all(1),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 20,),


               Row(
                 children: [
                   Column(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: [
                       Container(
                         padding: MediaQuery.of(context).size.height > 400? EdgeInsets.all(10) :EdgeInsets.all(1) ,
                         child: Text(" Lista de Tarefas deitado",
                             style:TextStyle(
                               fontSize:  MediaQuery.of(context).size.height > 400? 35:25,
                               fontWeight: FontWeight.w700,

                             )),
                       ),
                       Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.38 ,
                                child: TextField(
                                  controller: widget.c.controllerNewTask,
                                  focusNode: widget.c.focusNode,
                                  decoration: InputDecoration(
                                      label: Text("Adicione uma nova tarefa",
                                          style: TextStyle(fontSize: 15)),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),

                              ElevatedButton(
                                  onPressed:(){
                                    TaskModel novaTask = TaskModel(text: widget.c.controllerNewTask.text, isDark: !widget.c.isDart());
                                    print("tema: ${novaTask.isDark}");
                                    setState(() {
                                      if(widget.c.controllerNewTask.text == "") {
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
                                        widget.c.tarefas.add(novaTask);
                                        widget.c.taskrepo.saveTaskList(widget.c.tarefas);
                                        print(widget.c.tarefas.length);
                                        widget.c.controllerNewTask.clear();
                                        widget.c.focusNode.unfocus();
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

                       MediaQuery.of(context).size.height> 550? SizedBox(height: MediaQuery.of(context).size.height * 0.4)
                           :
                       SizedBox(height: MediaQuery.of(context).size.height * 0.001)
                       ,

                       Center(
                         child: Text("Você possue ${widget.c.qtsPendencia} tarefas pendentes",
                           style: TextStyle(fontSize:16,
                               color: widget.c.qtsPendencia>0?Colors.red:Colors.green),),
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
                                           Text(widget.c.tarefas.length==0?"Ta frescando é doido":(widget.c.limpar()?" - Apagar tarefas?":" - Apagar tudo?")),
                                         ],
                                       ),
                                       content: Text(widget.c.tarefas.length==0?"Tem nada para apagar não abestado" :(widget.c.limpar()?"Deseja realmente apagar todas as tarefas concluídas? Não será possível a recuperação dos dados após serem excluídos.":"Deseja realmente apagar tudo? Não será possível a recuperação dos dados após o delete.")),
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
                                               if(!widget.c.limpar()){
                                                 widget.c.tarefas.clear();
                                               }
                                               else {
                                                 for(int i=0;i<widget.c.tarefas.length;i++){
                                                   if(widget.c.tarefas[i].concluida){
                                                     widget.c.LastTask.add(widget.c.tarefas[i]);
                                                     widget.c.tarefas.removeAt(i);
                                                     i--;
                                                   }
                                                 }
                                               }

                                               widget.c.taskrepo.saveTaskList(widget.c.tarefas);
                                             });
                                           },)
                                       ]
                                   );
                                 });


                           },
                           child: Text(widget.c.limpar()?"Limpar tarefas concluídas":"Limpar tudo",
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 20,
                               )),
                           style: ElevatedButton.styleFrom(
                               padding: EdgeInsets.symmetric(
                                   horizontal:MediaQuery.of(context).size.width * 0.08 ,
                                   vertical:MediaQuery.of(context).size.height >400?20:12 ),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(20),
                               ),
                               backgroundColor: const Color.fromARGB(255, 255, 179, 0)
                           ),),
                       ),
                       SizedBox(height: 20,)
                     ],
                   ),

                SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: widget.c.tarefas.isEmpty? Center(child: Text("Nenhuma tarefa"))
                      : ListView.builder(
                      itemCount: widget.c.tarefas.length,
                      itemBuilder: (context, index){
                        return Task(
                          model: widget.c.tarefas[index],
                          OnDelete: () {
                            widget.c.LastDelete = widget.c.tarefas[index];
                            widget.c.LastDeletePos = index;
                            setState(() {
                              widget.c.tarefas.removeAt(index);
                              widget.c.taskrepo.saveTaskList(widget.c.tarefas);
                            });

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(

                                SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Text("Sua tarefa ${widget.c.LastDelete!.text} foi excluída",
                                        style: TextStyle(
                                          fontSize: 15,
                                        )),
                                    action: SnackBarAction(
                                      backgroundColor: Colors.transparent,
                                      onPressed: (){
                                        setState(() {
                                          widget.c.tarefas.insert(widget.c.LastDeletePos, widget.c.LastDelete!);
                                          widget.c.taskrepo.saveTaskList(widget.c.tarefas);
                                          // FocusScope.of(context).unfocus();
                                        });

                                      },
                                      label: "DESFAZER",
                                      textColor: widget.c.isDart()?  const Color.fromARGB(255, 26, 5, 254) : const Color.fromARGB(255, 5, 245, 254),

                                    )
                                )

                            );
                          },
                          OnEditing: (){
                            widget.c.taskrepo.saveTaskList(widget.c.tarefas);
                          },
                          OnChaged: (){
                            setState(() {
                              widget.c.taskrepo.saveTaskList(widget.c.tarefas);
                            });
                          },

                        );
                      }
                  ),
                )
          ]
      ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
