import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'histories_page.dart';
class TotalPage extends StatelessWidget {
TotalPage({super.key});

Future<DocumentSnapshot> getUserData(String userId) async {
return await FirebaseFirestore.instance.collection('Users').doc(userId).get();
}

@override
Widget build(BuildContext context) {
final currentUser = FirebaseAuth.instance.currentUser;
DocumentReference currentUserReference = FirebaseFirestore.instance.collection('Users').doc(currentUser!.uid.toString());
return StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('Money_total')
      .where('users', arrayContains: currentUserReference)
      .snapshots(),
  builder: (context, moneyTotalSnapshot) {
    if (moneyTotalSnapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    final moneyTotalDocs = moneyTotalSnapshot.data!.docs;
    return ListView.builder(
      itemCount: moneyTotalDocs.length,
      itemBuilder: (context, index) {
        DocumentSnapshot moneyTotalDoc = moneyTotalDocs[index];
        Map<String, dynamic> data = moneyTotalDoc.data()! as Map<String, dynamic>;
        List<dynamic> users = data['users'];
        bool owes = data['from'] == currentUserReference;
        List<String> userIds = [];
        for (DocumentReference userRef in users) {
          String userId = userRef.id;
          userIds.add(userId);
        }
        String otherUserId = userIds.firstWhere((u) => u != currentUser.uid);
        return FutureBuilder<DocumentSnapshot>(
          future: getUserData(otherUserId),
          builder: (context, otherUserSnapshot) {
            if (otherUserSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text(""));
            }
            final Map<String, dynamic>? otherUserData = otherUserSnapshot.data?.data() as Map<String, dynamic>?;
            String otherUserName = otherUserData?['displayname'];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => History(moneyTotalId: moneyTotalDoc.id)),);
              },
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                        owes ? "You owe $otherUserName" : "$otherUserName owes you",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${otherUserData?['email']}",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${data['total']}₸",
                        style:  TextStyle(
                          fontSize: 30,
                          color: owes ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  },
);
}
}