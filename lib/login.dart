import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'codelabs.dart';

import 'register.dart';
import 'forget_password.dart';
//import 'home.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _loginUser (BuildContext context) async{
    WidgetsApp.debugAllowBannerOverride = false;
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()),);
    }catch(e){
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),        
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                label: Text('Email',)
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                label: Text('Contraseña'),              
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0,),
            ElevatedButton(
              onPressed: () => _loginUser(context), 
              child: const Text('Login'),
            ),
            const SizedBox(height: 16.0,),
            TextButton(onPressed: (){Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()),
              );
            }, child: const Text('You don´t have a account yet?'),
            ),
            const SizedBox(height: 16.0,),
            TextButton(
              onPressed: (){Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
                );
              },
              child: const Text('Forgot your Password'),),
          ],
        ),
      ),
    );
  }
}