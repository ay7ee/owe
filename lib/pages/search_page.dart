import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:owe/pages/users_page.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final CollectionReference _usersCollectionRef =
      FirebaseFirestore.instance.collection('Users');
  late String? currentUserUid;
  @override
  void initState() {
    currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersCollectionRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('No data'));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child:CircularProgressIndicator());
          }
          List<DocumentSnapshot> usersList = snapshot.data!.docs.where((user) => user.get('uid') != currentUserUid).toList();
          return ListView.builder(
  itemCount: usersList.length,
  itemBuilder: (BuildContext context, int index) {
    String displayName = usersList[index].get('displayname');
    String email = usersList[index].get('email');
    String uid = usersList[index].get('uid');
    final Random random = Random(index);
    final int red = random.nextInt(255);
    final int green = random.nextInt(255);
    final int blue = random.nextInt(255);
    final Color color = Color.fromRGBO(red, green, blue, 1.0);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text(
            displayName.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
        title: Text(
          displayName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        subtitle: Text(
          email,
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20.0,
          color: Colors.grey,
        ),
        onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserPage(uid: uid)),);
        },
      ),
    );
  },
);

        },
      ),
    );
  }
}