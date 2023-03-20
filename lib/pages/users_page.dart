import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final String uid;

  const UserPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  
  String _forWhom = '';

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    CollectionReference moneyHistory = FirebaseFirestore.instance.collection('Money_history');
    CollectionReference moneyTotal = FirebaseFirestore.instance.collection('Money_total');
    DocumentReference firstUserReference = FirebaseFirestore.instance.collection('Users').doc(currentUser!.uid.toString());
    DocumentReference secondUserReference = FirebaseFirestore.instance.collection('Users').doc(widget.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
        backgroundColor:const Color.fromARGB(255, 224, 56, 208),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("${widget.uid}");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            String displayName = data['displayname'] ?? '';
            String email = data['email'] ?? '';
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          data['displayname'].substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      title: Text(displayName),
                      subtitle: Text(email),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _numberController,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _commentController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Comment',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            decoration: BoxDecoration(color:const Color.fromARGB(255, 224, 56, 208),borderRadius: BorderRadius.circular(5),),
                            child: TextButton(
                            onPressed: () async{
                              String ref = widget.uid.toString() + currentUser.uid.toString();
                              String ref2 = currentUser.uid.toString() + widget.uid.toString();
                              DocumentSnapshot snapshot = await moneyTotal.doc(ref).get();
                              if (!snapshot.exists) {
                                DocumentSnapshot snapshot2 = await moneyTotal.doc(ref2).get();
                                if (!snapshot2.exists) {
                                  await moneyTotal.doc(ref).set({
                                    'total': 0,
                                    'from': '',
                                    'users': ''
                                    });
                                  } else {
                                    ref = ref2;
                                  }
                                }
                              DocumentReference moneyTotalReference = FirebaseFirestore.instance.collection('Money_total').doc(ref);
                              await moneyHistory.doc().set({
                                'Money_total': moneyTotalReference, 
                                'comment': _commentController.text.trim(), 
                                'from': secondUserReference,
                                'money': int.parse(_numberController.text),
                                'to': firstUserReference, 
                                'date': DateTime.now()
                              });
                              int totalFromFirstUser = 0;
                              int totalFromSecondUser = 0;
                              QuerySnapshot historyFromFirstUser = await moneyHistory.where('from', isEqualTo:  firstUserReference).where('Money_total', isEqualTo: moneyTotalReference).get();
                              QuerySnapshot historyFromSecondUser = await moneyHistory.where('from', isEqualTo: secondUserReference).where('Money_total', isEqualTo: moneyTotalReference).get();
                              historyFromFirstUser.docs.forEach((doc) {
                                totalFromFirstUser += doc['money'] as int;
                              }); 
                              historyFromSecondUser.docs.forEach((doc) {
                                totalFromSecondUser += doc['money'] as int;
                              });
                              List<Object> users = [firstUserReference, secondUserReference];
                              int sum = totalFromFirstUser - totalFromSecondUser;
                              if(sum > 0){
                               await moneyTotal.doc(ref).update({
                                'total': sum.abs(),
                                'from': firstUserReference,
                                'users': users,
                                });
                              }else{
                               await moneyTotal.doc(ref).update({
                                'total': sum.abs(),
                                'from': secondUserReference,
                                'users': users,
                                });
                              }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("${data['displayname']} now owes ${_numberController.text}₸ more"),
                                    ));
                                  FocusScope.of(context).unfocus();
                                  _numberController.clear();
                                  _commentController.clear();
                            },
                            child:const Text( 'SAVE', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500))
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
