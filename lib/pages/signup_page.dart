import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:owe/pages/credentials_page.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
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
      appBar: AppBar(title: Text("Signup"), backgroundColor:const Color.fromARGB(255, 43, 137, 113),),
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
                decoration: BoxDecoration(color:const Color.fromARGB(255, 26, 162, 99),borderRadius: BorderRadius.circular(5),),
                child: TextButton(
                  onPressed: () async{
                  final email = _email.text.trim();
                  final password = _password.text.trim();
                  try{
                    final user = await FirebaseAuth.instance.createUserWithEmailAndPassword( email: email, password: password);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Credentials()),);
                    print(user);
                    }
                    on FirebaseAuthException catch(e){
                       setState(() {
                        errorCode = e.code;
                      });
                      print(e.code);
                     }
                    },
                  child:const Text( 'SIGN UP', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}