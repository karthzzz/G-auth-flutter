// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/widget/login_view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ScreenPro extends StatelessWidget {
  const ScreenPro(this.user, {super.key});

  final User user;

  Future<bool> signOut() async {
    final googleResult = await GoogleSignIn().signOut();
    print("User signed out");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          ElevatedButton(
              onPressed: () async {
                final result = await signOut();
                if (result) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (ctx) => LoginView(user)));
                }
              },
              child: const Text("Sign out"))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              user.displayName.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10,),
            Text(user.email! , style: Theme.of(context).textTheme.titleSmall,)
          ],
        ),
      ),
    );
  }
}
