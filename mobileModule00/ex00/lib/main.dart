import 'package:flutter/material.dart';

void main() {
  runApp(const MyAppMat());
}

class MyAppMat extends StatelessWidget {
  const MyAppMat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ex00',
      home: const MyApp(),
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.circular(10),
              ),
              child: (const Text(
                'A simple text',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontSize: 32,
                  fontWeight: FontWeight.normal,
                ),
              )),
            ),
            ElevatedButton(
              onPressed: () {
                print('Button pressed');
              },
              child: const Text('Press me'),
            )
          ],
        ),
      ),
    );
  }
}
