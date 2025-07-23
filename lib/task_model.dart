import 'package:intl/intl.dart';

class TaskModel{

   String text;
   bool concluida;
   bool isDark;
   String? time;

   TaskModel({String? time, 
   required this.text,
   this.isDark = false,
   this.concluida = false}) : time = time ?? DateFormat('dd/MM/yyyy - HH:mm').format(DateTime.now());

   TaskModel.fromJson(Map<String, dynamic> json)
   : text = json["text"],
     time = json["tempo"],
     concluida = json["concluida"] ?? false,
     isDark = json["isDark"] ?? false
   ;

Map<String, dynamic> toJson(){
  return {
    "text": text,
    "tempo": time,
    "concluida": concluida ?? false,
    "isDark": isDark ?? false,
  };
}

}