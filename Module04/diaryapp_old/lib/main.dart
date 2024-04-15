// import 'package:diaryapp/firebase_options.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';


void main() {
  runApp(const MainApp());
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(const MainApp());
// }

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainApp();
}

class _MainApp extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          child: const Center(
            child: Text('Hello World!!'),
          ),
        ),
      ),
    );
  }
}

