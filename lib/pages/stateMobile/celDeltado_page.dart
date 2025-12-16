import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tarefas/pages/home_page.dart';
import 'package:tarefas/controllers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:tarefas/main.dart';
import 'package:tarefas/pages/login_page.dart';
import 'package:tarefas/repositories/task_repo.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:tarefas/wids/pdf_view_page_pdf.dart';
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

    bool isDark = Theme.of(context).brightness == Brightness.dark;


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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [


                  IconButton(icon: Icon(Icons.picture_as_pdf), onPressed:() async{

                    List<String> tar = [];

                    for(int i=0;i<widget.c.tarefas.length;i++){

                      tar.add(widget.c.tarefas[i].tarefaName);

                    }

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PdfViewPagePdf(controller: widget.c)));

                  }),

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
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
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

                      }, icon: Icon(Icons.save)),

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
                      child: Icon(Icons.add)),
                  SizedBox(width: 20,),
                  //widget.c.isDart()?Icon(Icons.bedtime):Icon(Icons.brightness_4),
                ],
              ),

            ],
          )]

      ),
      onDrawerChanged: (context){
        widget.c.focusNode.unfocus();
      },

      drawer: Drawer(
        child: ListView(


          children: [

            UserAccountsDrawerHeader(
              accountName: Text(widget.c.userAuth?.displayName ?? "Sem nome"),
              accountEmail: Text(widget.c.userAuth?.email ?? "test@gmail.com"),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: widget.c.userAuth?.photoURL != null? CachedNetworkImageProvider(widget.c.userAuth?.photoURL ?? ''):AssetImage("assets/images/person.jpeg") as ImageProvider
              ),

            ),


            widget.c.userAuth == null? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Card(

                color: isDark? Color.fromRGBO(50, 50, 50, 1.0):

                Color.fromRGBO(
                    209, 209, 209, 1.0) ,
                child: InkWell(
                  child: SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 5,),
                        Text("LOGIN",
                            style: TextStyle(fontSize: 20) ),

                        //icone que muda conforme o thema

                        Icon(Icons.login)


                      ],
                    ),
                  ),
                  onTap: () async {
                    final user = await Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));

                    if(user != null){
                      setState(() {
                        widget.c.user = user;
                      });
                    }

                    setState(() {

                    });

                  },
                ),
              ),
            ) : SizedBox(),
            widget.c.userAuth != null? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Card(

                color: isDark? Color.fromRGBO(50, 50, 50, 1.0): Color.fromRGBO(
                    209, 209, 209, 1.0) ,
                child: InkWell(
                  child: SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 5,),
                        Text("LOGOUT",
                            style: TextStyle(fontSize: 20) ),

                        //icone que muda conforme o thema

                        Icon(Icons.logout)


                      ],
                    ),
                  ),
                  onTap: () async {

                    await FirebaseAuth.instance.signOut();

                    try{
                      await GoogleSignIn().signOut();
                    }catch(_){}

                    setState(() {

                    });

                  },
                ),
              ),
            ) : SizedBox(),

            widget.c.userAuth != null? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Card(

                color: isDark? Color.fromRGBO(50, 50, 50, 1.0): Color.fromRGBO(
                    209, 209, 209, 1.0) ,
                child:InkWell(
                  child: SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 5,),
                        Text("BAIXAR TAREFAS",
                            style: TextStyle(fontSize: 20) ),

                        //icone que muda conforme o thema

                        widget.c.isDownload? SizedBox(width: 24, height: 24,

                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          )

                          ,):Icon(Icons.cloud_download)


                      ],
                    ),
                  ),
                  onTap: () async {

                    setState(() {
                      widget.c.isDownload = true;
                    });

                    //List<String> lista = await TaskRepo.getList();

                    final batch = FirebaseFirestore.instance.batch();
                    final uid = widget.c.userAuth!.uid;

                    final snapshots = await FirebaseFirestore.instance
                        .collection(
                        "users")
                        .
                    doc(uid)
                        .collection("tasks").get();

                    final List lista = snapshots.docs.map((e)=> e.id).toList();


                    for(var name in lista) {

                      final doc = await FirebaseFirestore.instance.collection("users").
                      doc(widget.c.userAuth!.uid).collection("tasks").doc(name).get();


                      final List tarefasJson = doc.data()?["tarefas"] ?? [];

                      List<TaskModel>tarefas = tarefasJson.map((e)=> TaskModel.fromJson(e)).toList();

                      if(name == lista.last){
                        setState(() {
                          widget.c.tarefas = tarefas;
                          widget.c.nameList = name;
                        });

                      }
                      widget.c.taskrepo.setArqList(name);
                      widget.c.taskrepo.saveTaskList(tarefas);


                      print(name);
                      for(var l in tarefas) {

                        print("");
                        print(l.toString());
                        print("");
                      }
                      print("");
                      print("");
                      print("");
                      print("");
                      print("");
                      print("");

                    }

                    setState(() {
                      widget.c.isDownload= false;
                      Navigator.pop(context);
                    });



                  },
                ),
              ),
            ) : SizedBox(),

            widget.c.userAuth != null? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Card(

                color: isDark? Color.fromRGBO(50, 50, 50, 1.0): Color.fromRGBO(
                    209, 209, 209, 1.0) ,
                child: GestureDetector(
                    child: SizedBox(
                      height: 70,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(width: 5,),
                          Text("ENVIAR PARA NUVEM",
                              style: TextStyle(fontSize: 20) ),

                          //icone que muda conforme o thema

                          widget.c.isUpload? SizedBox(width: 24, height: 24

                            ,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            )
                            ,):Icon(Icons.cloud_upload)


                        ],
                      ),
                    ),
                    onTap: () async {
                      setState(() {
                        widget.c.isUpload= true;
                      });

                      showDialog(context: context, builder: (context){

                        return AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
                              Text("UPLOAD DE ARQUIVOS", style: TextStyle(fontSize: 20),),
                            ],
                          ),
                          content: Text("Deseja enviar todos os arquivos ou apenas a tarefa atual?"),

                          actions: [
                            // TextButton(child: Text("CANCELAR"), onPressed: (){},),
                            TextButton(child: Text("ATUAL"), onPressed: () async {

                              Navigator.pop(context);


                              List<TaskModel> tarefas =  widget.c.tarefas;
                              final batch = FirebaseFirestore.instance.batch();
                              final uid = widget.c.userAuth!.uid;




                              final ref = FirebaseFirestore.instance.collection("users").doc(uid).collection("tasks").doc(widget.c.nameList);

                              batch.set(ref, {
                                "tarefas": tarefas.map((e) => e.toJson()).toList(),
                              });


                              await batch.commit();
                              setState(() {
                                widget.c.isUpload = false;
                              });




                            },),
                            TextButton(child: Text("TODOS"), onPressed: () async{



                              Navigator.pop(context);


                              List<String> lista = await TaskRepo.getList();

                              final batch = FirebaseFirestore.instance.batch();
                              final uid = widget.c.userAuth!.uid;

                              for(var nomeLista in lista){

                                List<TaskModel> tarefas = await TaskRepo(nomeLista).getTaskList();


                                final ref = FirebaseFirestore.instance.collection("users").doc(uid).collection("tasks").doc(nomeLista);

                                batch.set(ref, {
                                  "tarefas" : tarefas.map( (e) => e.toJson()).toList()
                                });


                              }
                              await batch.commit();
                              setState(() {
                                widget.c.isUpload = false;

                              });
                            },),
                          ],
                        );

                      });


                    }
                ),
              ),
            ) : SizedBox(),



            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Card(

                color: isDark? Color.fromRGBO(50, 50, 50, 1.0): Color.fromRGBO(
                    209, 209, 209, 1.0) ,
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

                      isDark?Icon(Icons.bedtime):Icon(Icons.brightness_4),

                      Switch(value: isDark,
                          onChanged: (value){
                            setState(() {
                              widget.c.alterarThema();
                              isDark = value;
                            });



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
                         child: Text(" Lista de Tarefas",
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
                                    TaskModel novaTask = TaskModel(text: widget.c.controllerNewTask.text);
                                   // print("tema: ${novaTask.isDark}");
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
