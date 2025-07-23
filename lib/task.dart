import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tarefas/task_model.dart';


class Task extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final void Function()? OnDelete;
  final void Function()? OnChaged;
  final void Function()? OnEditing;
  final TaskModel model;

  const Task({
    super.key,
    this.OnDelete,
    this.OnChaged,
    this.OnEditing,
    required this.model
    });

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {

   DateTime agora = DateTime.now();
   String Date="";
   TextEditingController _controller = TextEditingController();
  

   @override
   void initState(){
    super.initState();
    setDate();
   }
   
   void setDate(){
   setState(() {

    Date = widget.model.time ?? DateFormat('dd/MM/yyyy - HH:mm').format(agora);
   // widget.model.time = Date;
   });
   }


  Color checado(Set<WidgetState> states){

    if(widget.model.concluida){
      return Colors.green;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {


 
    return Slidable(

     endActionPane: ActionPane(
      extentRatio: 0.25,
      motion: const DrawerMotion(),
      children: [
        SlidableAction(onPressed: (_){
          if(widget.OnDelete != null) {
            widget.OnDelete!();

            
          }
         
          },
        backgroundColor: Colors.red,
        icon: Icons.delete,
        label: 'DEL',
        ),
      ],
     ),
     startActionPane:  ActionPane(
      extentRatio: 0.25,
      motion: const DrawerMotion(),
      children: [
        SlidableAction(onPressed: (_){

          _controller.text = widget.model.text;
          
         showDialog(context: context,

          builder: (context) {

            return AlertDialog(
               title: Text("Editar"),
               content: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  label: Text('Reescreva'),
                  border: OutlineInputBorder(
          
                  )
                ),
               ),
               actions: [
                TextButton(onPressed: (){
                  Navigator.of(context).pop();
                },
                 child: Text("CANCELAR"),
                 ),
                 TextButton(onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {
                    widget.model.text = _controller.text;
                    //

                  if(widget.OnEditing != null) {
                    widget.OnEditing!();

            
                      }

                    
                  });
                 },
                 child: Text("OK"),
                 )
               ],
            );
          }
          
          );

        },
        backgroundColor: const Color.fromARGB(255, 2, 196, 255),
        icon: Icons.edit,
        label: 'EDIT',
        )
      ],
     ),
        child: Container(
          width: 500,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                 width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                       ListTile(
                       title: Text(widget.model.text ?? "null",
                       style: TextStyle(fontSize:19, 
                       fontWeight: FontWeight.bold,
                       color: widget.model.concluida == false? (widget.model.isDark?Colors.white:Colors.black): Colors.green
                       )),
    
                       subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text("" + Date,
                     style: TextStyle(
                      color: widget.model.concluida ==false? (widget.model.isDark?Colors.white: Colors.black) : Colors.green
                     )),
                     SizedBox(height: 2,),
                           Text(widget.model.concluida==false? "STATUS: PENDENTE":"STATUS: CONCLUIDA",
                           style: TextStyle(color: widget.model.concluida==false? Colors.red : Colors.green)),
                           
                         ],
                       ),
                     ),
                    
                     SizedBox(height: 2,),
                    
                     SizedBox(height: 1,)
                    ],
                  ),
                ),
               // SizedBox(width: 150,),
                Checkbox(value: widget.model.concluida, 
                onChanged:(bool? newValue){
                   setState(() {
                     widget.model.concluida = newValue!;
                   });
                   if(widget.OnChaged != null){
                    widget.OnChaged!();
                   }
                },

                fillColor: WidgetStateColor.resolveWith(checado)
                ,
                
                 )
              ],
            )
          ),
        ),
        ),

    );
  }
}