import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class ListTarefasRepo {


  static String nameKey = "ListRepo";

  static Future<void> setList(List<String?> repoList) async {
    final shared = await SharedPreferences.getInstance();
    String decode = json.encode(repoList);
    shared.setString(nameKey, decode);
  }

  static Future<List<String>> getList() async {
    final shared = await SharedPreferences.getInstance();
    String? repo = shared.getString(nameKey);
    List<String> traduzir = List<String>.from(json.decode(repo ?? "[]"));
    return traduzir;
  }


}