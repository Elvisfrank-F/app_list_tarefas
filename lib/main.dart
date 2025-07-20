import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tarefas/repositories/task_repo.dart';
import 'package:tarefas/task_model.dart';
import 'task.dart';

import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(
    ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          home: HomePage(),
        );
      },
    ),
  );
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<TaskModel>tarefas = [];
  List<Text>vazio = [Text("")];
  TextEditingController _controller = TextEditingController();
  int get qtdTask => tarefas.length;
  int get qtsPendencia => tarefas.where((tarefa) => !tarefa.concluida).length;

  //variáveis usadas para desfazer a delete
  TaskModel LastDelete = TaskModel(text: "");
  int LastDeletePos = 0;

  //instanciando o repositório para armazenagem e reciclagem de dados

  final TaskRepo taskrepo = TaskRepo();

  bool isDark = false;

  @override
  void initState(){
    super.initState();

    

    taskrepo.getTaskList().then(
      (value){
        setState(() {
          tarefas = value;
        });
        
      }
    );
  }
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Lista de tarefas")),
      
      
      drawer: Drawer(
        child: Column(
          children: [
            Card(
              color: Colors.grey,
              child: SizedBox(
                height: 70,
                width: double.infinity,
                child: Switch(value: isDark,
                 onChanged: (value){
                  themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                 }),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Text("Lista de tarefas",
                style:TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  
                )),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 260,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        label: Text("Digite uma tarefa"),
                        border: OutlineInputBorder()
                      )
                    )),
                    //SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed:(){
                      TaskModel novaTask = TaskModel(text: _controller.text);
                      setState(() {
                        if(_controller.text == "") {
                            showDialog(
                              context: context, 
                              builder: (context) {
                                
                                return AlertDialog(
                                  title: Text('DÊ UM NOME',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800
                                  )),
                                  content: Text('Faz-se necessário pôr o nome da tarefa',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                                  actions: [
                                    TextButton(onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                         tarefas.add(novaTask);
                                          taskrepo.saveTaskList(tarefas);
                                      });

                                     
                                     
                                    }, child: Text("Adicionar mesmo assim")),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
        
                                      }, child: Text("OK"),
                                    ),
                                  ],
                                );
                              });
                        }
                        else {
                       tarefas.add(novaTask);
                        taskrepo.saveTaskList(tarefas);
                       print(tarefas.length);
                       _controller.text = "";
                        }
                      });
                      
                    } ,
                     child: Icon(Icons.add, size: 30),
                     style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      backgroundColor: const Color.fromARGB(255, 0, 204, 255)
                     ))
                ],
              ),
              SizedBox(height: 20,),
              Expanded(
                child: tarefas.isEmpty? Center(child: Text("Nenhuma tarefa"))
                : ListView.builder(
                 itemCount: tarefas.length,
                 itemBuilder: (context, index){
                  return Task(
                    model: tarefas[index],
                    OnDelete: () {
                      LastDelete = tarefas[index];
                      LastDeletePos = index;
                      setState(() {
                        tarefas.removeAt(index);
                        taskrepo.saveTaskList(tarefas);
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
                     tarefas.insert(LastDeletePos, LastDelete);
                     taskrepo.saveTaskList(tarefas);
                  });
                 
                },
                label: "DESFAZER",
                textColor: const Color.fromARGB(255, 5, 245, 254),
    
              )
              )
              
            );
                    },
                    OnEditing: (){
                      taskrepo.saveTaskList(tarefas);
                    },
                    OnChaged: (){
                      setState(() {
                        taskrepo.saveTaskList(tarefas);
                      });
                    },

                  );
                 }
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                
                Text("Você possue $qtsPendencia tarefas pendentes",
                style: TextStyle(fontSize:16,
                color: qtsPendencia>0?Colors.red:Colors.green),),
                //SizedBox(width: 40,),
                ElevatedButton(
                  onPressed: (){

                   showDialog(context: context,
                   builder: (context) {
                    return AlertDialog(
                    title: Text("Apagar tudo?"),
                    content: Text("Deseja realmente apagar tudo?"),
                    actions: [
                      TextButton(child: Text("Cancelar"), onPressed: (){
                        Navigator.of(context).pop();
                      }),
                      TextButton(child: Text("Apagar"), onPressed: (){
                        Navigator.of(context).pop();
                        setState(() {
                      tarefas.clear();
                      taskrepo.saveTaskList(tarefas);
                    });
                      },)
                    ]
                    );
                  });

                    
                  }, 
                  child: Text("Limpar",
                  style: TextStyle(
                    fontSize: 20,
                  )),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    shape: RoundedRectangleBorder(),
                    backgroundColor: const Color.fromARGB(255, 0, 204, 255)
                  ),)
              ],),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}