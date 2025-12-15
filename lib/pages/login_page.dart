import 'package:flutter/material.dart';
import 'package:tarefas/funcs/login_func.dart';
import 'package:tarefas/wids/button_login.dart';
import 'package:tarefas/wids/button_loginGB.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Card(
          elevation: 100,
          color: Color.fromRGBO(48, 48, 48, 1.0),
          child: Container(
            padding: EdgeInsets.all(10),


            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("FAÇA LOGIN", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600), ),
                SizedBox(height: 20,),
                ButtonLogin(onPressed: () async{

                  try {
                    final user = await LoginFunc.signInWithGoogle();

                    if(user != null){
                      Navigator.pop(context, user);
                    }
                  }
                  catch(e){
                    print(e);
                  }




                },),
                SizedBox(height: 10,),
                ButtonLoginGB()

              ],
            ),
          ),
        ),
      ),
    );
  }
}
