import 'package:intl/intl.dart';

class TaskModel{

   String text;
   bool concluida;
   String? time;

   TaskModel({String? time, 
   required this.text
   , 
   this.concluida = false}) : time = time ?? DateFormat('dd/MM/yyyy - HH:mm').format(DateTime.now());

   TaskModel.fromJson(Map<String, dynamic> json)
   : text = json["text"],
     time = json["tempo"],
     concluida = json["concluida"] ?? false
   ;

Map<String, dynamic> toJson(){
  return {
    "text": text,
    "tempo": time,
    "concluida": concluida ?? false,
  };
}

}