import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:owe/pages/edit_profile_page.dart';
import 'package:owe/pages/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'change_password_page.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.5).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onLogoutPressed(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You have been logged out'),
      ),
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("email");
    Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomePage()),);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              ScaleTransition(
                scale: _animation,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blueGrey,
                  child: Text(
                    user?.displayName?[0].toUpperCase() ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                user?.displayName ?? '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                user?.email ?? '',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Edit Profile'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile()),);
                },
              ),
              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Change Password'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePassword()),);
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () => _onLogoutPressed(context),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
