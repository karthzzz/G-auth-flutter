import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness/screen/screenPro.dart';
import 'package:fitness/widget/login_view.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() {
  // 8:55 - widget initialization
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  bool _isUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              print("----------------------------");
              print(FirebaseAuth.instance.currentUser);

              final user = FirebaseAuth.instance.currentUser;

              if (user?.emailVerified ?? false) {
                print("User is verified");
                _isUser = true;
              } else {
                print("User is not verified");
                _isUser = false;
              }
              return _isUser ? ScreenPro(user!) : LoginView(user!);
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
