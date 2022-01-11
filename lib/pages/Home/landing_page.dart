import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resturante_de_tante/pages/Menu/Waiter/continent_name.dart';
import 'package:resturante_de_tante/pages/Menu/Chef/chef_page.dart';
import 'package:resturante_de_tante/pages/Home/login_page.dart';

//instance to get the user ID
FirebaseAuth user = FirebaseAuth.instance;

// String? role;

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //to get the current status of FireB
          if (snapshot.hasData && snapshot.data != null) {
            return StreamBuilder<DocumentSnapshot>(
                //get the current user
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(user.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context, dynamic snapshot) {
                  if (snapshot.hasError) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  //snapshot user data
                  final userDoc = snapshot.data.data();

                  if (userDoc['Role'] == 'Chef') {
                    return const ChefPage();
                  } else {
                    return const ContinentName();
                  }
                });
          }
          return const LoginPage();
        });
    // ignore: dead_code
    // setState(() {});
  }
}
