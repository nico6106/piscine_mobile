import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

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
          child: AppBodyWidget(),
        ),
      ),
    );
  }
}

class AppBodyWidget extends StatelessWidget {
  AppBodyWidget({
    super.key,
  });

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    print('===>start');
    try {
      print('===>try');
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      print('===>await googleSignIn');
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount!.authentication;
      print('===>await authentification');
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      // print(userCredential);

      if (userCredential.user != null) {
        // Rediriger vers la nouvelle page après la connexion réussie
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NewPage()),
        );
      }

      return userCredential;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            await signInWithGoogle(context);
          },
          child: const Text('Sign in with Google'),
        ),
      ],
    );
  }
}

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Page'),
      ),
      body: const Center(
        child: Text('Welcome to the new page!'),
      ),
    );
  }
}
