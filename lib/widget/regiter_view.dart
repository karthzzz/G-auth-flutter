import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness/screen/screenPro.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_options.dart';

// ignore: must_be_immutable
class RegisterView extends StatefulWidget {
  RegisterView(this.user, {super.key});

  User? user;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      
                      try {
                        final UserCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        print(UserCredential);
                      } on FirebaseAuthException catch (e) {
                        print("=====================================");
                        if (e.code == "weak-password") {
                          print(e.code);
                          print("weak pwd! :-/ ");
                        } else if (e.code == "email-already-in-use") {
                          print(e.code);
                          print("email already in use");
                        } else if (e.code == "invalid-email") {
                          print(e.code);
                          print("invalid email");
                        } else {
                          print(e.code);
                          print(e);
                        }
                      }
                    },
                    child: const Text("Register"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: ()=> Navigator.of(context).pop(),
                    child: Text('Hava an account?'),
                  ),
                  const SizedBox(height: 10,),
                  TextButton(onPressed: () async{
                    var result = await signInWithGoogle();
                    
                    if(result != null){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>  ScreenPro(widget.user!)));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign in success"))); 
                    } 
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign in failed")));}

                  }, child: Text("Google"))
                ],
              );
            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}


 

Future<UserCredential>  signInWithGoogle() async {
  // Trigger the authentication flow
  final google = GoogleSignIn();
  final GoogleSignInAccount? googleUser = await google.signIn();  

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential) ;
}


void signOut() async{
  await GoogleSignIn().signOut();
  print("User signed out");
}