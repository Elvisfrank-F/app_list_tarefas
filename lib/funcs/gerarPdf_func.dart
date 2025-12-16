import 'dart:async';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:tarefas/controllers/task_controller.dart';
import 'package:tarefas/wids/task.dart';

import '../models/task_model.dart';


class GerarpdfFunc {

   TaskController? _controller;

  GerarpdfFunc(TaskController c){
    this._controller = c;
  }



  Future<Uint8List> gerarPdfBytes() async{

     final pdf = pw.Document();

     pdf.addPage(

       pw.Page(
         build: (context){

           return pw.Center(

               child: pw.Container(

                   child: pw.Column(
                       children: [
                         pw.Text("${_controller!.nameList!.toUpperCase()}", style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
                         pw.SizedBox(height: 40),
                         pw.Divider(thickness: 1),
                       //  pw.Divider(thickness: 1),

                         ..._controller!.tarefas.map((t) {

                           return pw.Column(

                               children: [

                                 pw.Row(
                                   //  mainAxisSize: pw.MainAxisSize.min,

                                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                     children: [

                                       pw.Expanded(
                                           child:  pw.Text('- ${t.tarefaName}', softWrap: true)
                                       ),

                                       pw.SizedBox(width: 30),
                                       pw.Container(width: 15, height: 15,
                                           decoration: pw.BoxDecoration(
                                               border: pw.Border.all(width: 1)
                                           )),


                                     ]
                                 ),

                                 pw.Divider(thickness: 1)

                               ]

                           );



                         }),

                       ]
                   )
               )
           );

         }
       )

     );

     return pdf.save();



  }

}