import 'package:authentication/security/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Display extends StatelessWidget {
  Display({super.key});

  final user = FirebaseAuth.instance.currentUser;
  final color = Colors.black45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text("Sign in as ${user.email!}"),
          const Text("You have successfully signed in"),
          const SizedBox(height: 10.0),
          MaterialButton(
            onPressed: (() {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return const LoginScreen();
              }), (route) => false);
            }),
            color: color,
            child: const Text(
              "Sign Out",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      )),
    );
  }
}
