import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {

  final VoidCallback onPressed;

  const ButtonLogin({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(3),
      child:  ElevatedButton(onPressed: onPressed, child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          Image.asset("assets/images/g-removebg.png",
            width: 50,
            height: 50,),
          Text(" Sign In with Google"),

        ],
      ),
        style: ElevatedButton.styleFrom(



            maximumSize: Size(MediaQuery.of(context).size.width*0.7, 200),

          side:  BorderSide(
            color: isDark? Colors.white : Colors.black,
            width: 2
          ),
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          )
        )
        ,)

    );
  }
}
