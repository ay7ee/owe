import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class History extends StatelessWidget {
  final String moneyTotalId;

  const History({Key? key, required this.moneyTotalId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    DocumentReference moneyTotalReference =
        FirebaseFirestore.instance.collection('Money_total').doc(moneyTotalId);
    return Scaffold(
      appBar: AppBar(
        title: Text('debt history'),
        backgroundColor: Color.fromARGB(255, 41, 233, 105),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Money_history')
              .where('Money_total', isEqualTo: moneyTotalReference)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final amount = data['money'];
                final comment = data['comment'];
                final fromUserReference = data['from'];
                final timestamp = (data['date'] as Timestamp).toDate();

                return FutureBuilder<DocumentSnapshot>(
                  future: fromUserReference.get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final fromUserData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final fromUserName = fromUserData['displayname'];
                    final bool me = currentUser?.displayName == fromUserName;  

                    return ListTile(
                      leading: Icon(Icons.payment),
                      title: Text(
                        me?'You borrowed $amount' : '$fromUserName borrowed $amount',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment),
                          SizedBox(height: 4),
                          Text(
                            '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}',
                            style: TextStyle(fontSize: 12),
                          ),
                          const Gap(5),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
