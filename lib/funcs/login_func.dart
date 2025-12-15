import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginFunc {

  static Future<UserCredential> signInWithGoogle() async{

    final googleUser = await GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/userinfo.profile'
      ]
    ).signIn();

    if(googleUser == null){
      throw Exception("Login cancelado");
    }

    //pegar autenticação do google

    final googleAuth = await googleUser.authentication;

    //Criar credenciais do firebase

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    //fazer login no firebase auth

    return FirebaseAuth.instance.signInWithCredential(credential);

  }



}