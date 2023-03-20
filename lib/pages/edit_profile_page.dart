import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:owe/pages/profile_page.dart';

import 'bottom_bar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late final TextEditingController _displayName;
  late CollectionReference users;
  String errorCode = '';

  @override
  void initState() {
    _displayName = TextEditingController();
    users = FirebaseFirestore.instance.collection('Users');
    super.initState();
  }

  @override
  void dispose() {
    _displayName.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit username"), backgroundColor:const Color.fromARGB(255, 240, 138, 88),),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                  ],
                keyboardType: TextInputType.name,
                autocorrect: false,
                controller: _displayName,
                decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Your username",),
               ),
            Row(
               children: [Text("${errorCode}", style: const TextStyle(color: Colors.red),)],
              ),
             const Gap(20),
              Container(
                width: 100,
                decoration: BoxDecoration(color:const Color.fromARGB(255, 240, 138, 88),borderRadius: BorderRadius.circular(5),),
                child: TextButton(
                  onPressed: () async{
                  final displayName = _displayName.text.trim();
                  try{
                    await Firebase.initializeApp();
                    final user = await FirebaseAuth.instance.currentUser;

                    if(displayName == null){
                      setState(() {
                        errorCode = "Zhazsai ept";
                      });
                    }
                    else{
                      user?.updateDisplayName(displayName);
                      users.doc("${user?.uid}").set({
                            'displayname': displayName, 
                            'email': user?.email, 
                            'uid': user?.uid 
                          })
                          .then((value) => print("User Added"))
                          .catchError((error) => print("Failed to add user: $error"));
                          
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  Profile()),);
                    print(user);
                    }
                    on FirebaseAuthException catch(e){
                      print(e.code);
                      setState(() {
                        errorCode = e.code;
                      });
                     }
                    },
                  child:const Text( 'Save', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500))
                ),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}

    