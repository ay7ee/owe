import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_bar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  String errorCode = '';
  bool passwordVisible = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    passwordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"), backgroundColor:Color.fromARGB(255, 15, 71, 136),),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                controller: _email,
                decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Your Email",),
               ),
              TextFormField(
                controller: _password,
                autocorrect: false,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                hintText: 'Your password',
                border: InputBorder.none,
                suffixIcon: IconButton(icon: Icon(passwordVisible? Icons.visibility: Icons.visibility_off,color: Colors.grey, size: 20,),
                onPressed: () {
                 setState(() {passwordVisible = !passwordVisible;});
                },
               ),
              ),
             ),
             Row(
               children: [Text("${errorCode}", style: const TextStyle(color: Colors.red),)],
              ),        
             const Gap(20),
              Container(
                width: 100,
                decoration: BoxDecoration(color:const Color.fromARGB(255, 15, 71, 136),borderRadius: BorderRadius.circular(5),),
                child: TextButton(
                  onPressed: () async{
                  final email = _email.text.trim();
                  final password = _password.text.trim();
                  try{
                    await Firebase.initializeApp();
                    final user = await FirebaseAuth.instance.signInWithEmailAndPassword( email: email, password: password);
                    SharedPreferences pref =await SharedPreferences.getInstance();
                    pref.setString("email", email);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomBar()),);
                    }
                    on FirebaseAuthException catch(e){
                       setState(() {
                        errorCode = e.code;
                      });
                      print(e);
                     }
                    },
                  child:const Text( 'LOGIN', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}