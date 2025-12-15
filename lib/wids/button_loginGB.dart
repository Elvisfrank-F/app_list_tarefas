import 'package:flutter/material.dart';

class ButtonLoginGB extends StatelessWidget {
  const ButtonLoginGB({super.key});

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
        padding: EdgeInsets.all(3),
        child:  ElevatedButton(onPressed: (){}, child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            ClipOval(
              child:  Image.asset(!isDark? "assets/images/git_light-removebg.png" : "assets/images/git_dark-removebg.png",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              
              
              ),
            ),
            Text("Sign in with Github", style: TextStyle(color: !isDark? Colors.black : Colors.white),),

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
