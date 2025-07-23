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
          debugShowCheckedModeBanner: false,
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

  final FocusNode _focusNode = FocusNode();
  

  //função que retorna a quantidade de atividades pendentes
  int get qtsPendencia => tarefas.where((tarefa) => !tarefa.concluida).length;

  //variáveis usadas para desfazer a delete
  late TaskModel LastDelete;
  int LastDeletePos = 0;

  //lista usada para esfazer o limpar tudo

  List<TaskModel> LastTask = [];

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
          
          if(tarefas.length>0){
            if(tarefas[0].isDark){
              themeNotifier.value = ThemeMode.dark;
            }
          }

        });
        
      }
    );

    if(tarefas.isNotEmpty) print("verificando se é true ${tarefas[0].isDark}");
    if(tarefas.isEmpty) print("ta vazio");


  }

  

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

  
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(""),
          isDart()?Icon(Icons.bedtime):Icon(Icons.brightness_4),
          
        ],
      )),
      onDrawerChanged: (context){
        _focusNode.unfocus();
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
              
                      isDart()?Icon(Icons.bedtime):Icon(Icons.brightness_4),
              
                      Switch(value: themeNotifier.value == ThemeMode.dark,
                       onChanged: (value){
                        themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                        for(int i=0;i<tarefas.length;i++){
                          if(isDart()){
                            tarefas[i].isDark = true;
                          }
                          else {
                            tarefas[i].isDark = false;
                          }
                        }
                        taskrepo.saveTaskList(tarefas);
                        _focusNode.unfocus();
                        
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
                            controller: _controller,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              label: Text("Adicione uma nova tarefa",
                              style: TextStyle(fontSize: 15)),
                              border: InputBorder.none
                            ),
                          ),
                        ),
                  
                           ElevatedButton(
                    onPressed:(){
                      TaskModel novaTask = TaskModel(text: _controller.text, isDark: isDart());
                      print("tema: ${novaTask.isDark}");
                      setState(() {
                        if(_controller.text == "") {
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
                       tarefas.add(novaTask);
                        taskrepo.saveTaskList(tarefas);
                       print(tarefas.length);
                       _controller.clear();
                       _focusNode.unfocus();
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
                      // FocusScope.of(context).unfocus();
                    });
                   
                  },
                  label: "DESFAZER",
                  textColor: isDart()?  const Color.fromARGB(255, 26, 5, 254) : const Color.fromARGB(255, 5, 245, 254),
              
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
                          Text(tarefas.length==0?"Ta frescando é doido":(limpar()?" - Apagar tarefas?":" - Apagar tudo?")),
                        ],
                      ),
                      content: Text(tarefas.length==0?"Tem nada para apagar não abestado" :(limpar()?"Deseja realmente apagar todas as tarefas concluídas? Não será possível a recuperação dos dados após serem excluídos.":"Deseja realmente apagar tudo? Não será possível a recuperação dos dados após o delete.")),
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
                            if(!limpar()){
                              tarefas.clear();
                            }
                            else {
                              for(int i=0;i<tarefas.length;i++){
                                if(tarefas[i].concluida){
                                  LastTask.add(tarefas[i]);
                                  tarefas.removeAt(i);
                                  i--;
                                }
                              }
                            }
                       
                        taskrepo.saveTaskList(tarefas);
                      });
                        },)
                      ]
                      );
                    });
                  
                      
                    }, 
                    child: Text(limpar()?"Limpar tarefas concluídas":"Limpar tudo",
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