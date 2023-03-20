import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:owe/pages/login_page.dart';
import 'package:owe/pages/signup_page.dart';

import 'credentials_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            InkWell(  
              // ignore: sort_child_properties_last
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const  Color.fromARGB(255, 47, 224, 180),
                ),
                child:const  Text("Login",),
              ),
              onTap: (() =>   Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),)),
            ),
            const Gap(40),
            InkWell(
              // ignore: sort_child_properties_last
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const  Color.fromARGB(255, 94, 119, 233),
                ),
                child:const Text("Sign up"),
              ),
            onTap: (() =>   Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup()),))),
          ],
        ),
      ),
    );
  }
}