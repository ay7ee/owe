import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'bottom_bar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late final TextEditingController _password;
  late final TextEditingController _password2;
  String errorCode = '';
  bool passwordVisible = false;

  @override
  void initState() {
    _password2 = TextEditingController();
    _password = TextEditingController();
    passwordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    _password2.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password"), backgroundColor:const Color.fromARGB(255, 133, 19, 89),),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: _password,
                autocorrect: false,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                hintText: 'New password',
                border: InputBorder.none,
                suffixIcon: IconButton(icon: Icon(passwordVisible? Icons.visibility: Icons.visibility_off,color: Colors.grey, size: 20,),
                onPressed: () {
                 setState(() {passwordVisible = !passwordVisible;});
                },
               ),
              ),
             ),
            TextFormField(
                controller: _password2,
                autocorrect: false,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                hintText: 'Confirm password',
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
                width: 150,
                decoration: BoxDecoration(color:const Color.fromARGB(255, 133, 19, 89),borderRadius: BorderRadius.circular(5),),
                child: TextButton(
                  onPressed: () async{
                  final password = _password.text.trim();
                  final password2 = _password2.text.trim();
                  if(password == password2){
                  try{
                    await Firebase.initializeApp();
                    final user = await FirebaseAuth.instance.currentUser;
                    await user?.updatePassword(password);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomBar()),);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Successfully changed"),
                      ));
                    FocusScope.of(context).unfocus();                    
                    }
                    on FirebaseAuthException catch(e){
                       setState(() {
                        errorCode = e.code;
                      });
                      print(e);
                     }
                  }
                  else{
                    _password2.clear();
                      setState(() {
                        errorCode = "password-mismatch";
                      });
                  }

                },
                  child:const Text( 'Change Password', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}