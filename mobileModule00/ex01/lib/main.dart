import 'package:flutter/material.dart';

void main() {
  runApp(const MyAppMat());
}

class MyAppMat extends StatelessWidget {
  const MyAppMat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ex01',
      home: const MyApp(),
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  String text = 'A simple text';

  void _amendText() {
    setState(() {
      if (text == 'A simple text') {
        text = 'Hello World!';
      } else {
        text = 'A simple text';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            MainTextWidget(show: text),
            ElevatedButton(
              onPressed: () {
                _amendText();
              },
              child: const Text('Press me'),
            )
          ],
        ),
      ),
    );
  }
}

class MainTextWidget extends StatelessWidget {
  const MainTextWidget({super.key, required this.show});

  final String show;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.circular(10),
      ),
      child: (Text(
        show,
        style: const TextStyle(
          color: Colors.white,
          decoration: TextDecoration.none,
          fontSize: 32,
          fontWeight: FontWeight.normal,
        ),
      )),
    );
  }
}
