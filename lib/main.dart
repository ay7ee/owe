import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:owe/pages/bottom_bar.dart';
import 'package:owe/pages/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs =await SharedPreferences.getInstance();
  var email=prefs.getString("email");
  runApp(MaterialApp(
      title: 'OweMate',
      debugShowCheckedModeBanner: false,
      home: email==null?WelcomePage():MyApp(),
    ),
  );
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
          builder:(context, snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.done:
                  return const BottomBar();
               default:
              return const Center(child: Text("Loading..."));
            }
          },
        ),
    );
  }
}
