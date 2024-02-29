import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Ex02',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Calculator')),
        backgroundColor: Colors.blueGrey,
      ),
      body: const BodyWidget(),
    );
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({
    super.key,
  });

  @override
  State<BodyWidget> createState() => _BodyWidget();
}

class _BodyWidget extends State<BodyWidget> {
  String lastkey = '';

  void _showKey(String text) {
    setState(() {
      print('button press :$text');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: ShowResultsWidget(),
        ),
        Expanded(
          child: ShowButtonsWidget(onPressed: _showKey),
        )
      ],
    );
  }
}

class ShowButtonsWidget extends StatelessWidget {
  const ShowButtonsWidget({required this.onPressed, super.key});

  final Function(String) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Column(children: [
        Expanded(child: firstRow()),
        Expanded(child: secondRow()),
        Expanded(child: thirdRow()),
        Expanded(child: lastRow()),
      ]),
    );
  }

  Row firstRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('7');
            },
            child: const Text('7'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('8');
            },
            child: const Text('8'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('9');
            },
            child: const Text('9'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('C');
            },
            child: const Text('C'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('AC');
            },
            child: const Text('AC'),
          ),
        ),
      ],
    );
  }

  Row secondRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('4');
            },
            child: const Text('4'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('5');
            },
            child: const Text('5'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('6');
            },
            child: const Text('6'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('+');
            },
            child: const Text('+'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('-');
            },
            child: const Text('-'),
          ),
        ),
      ],
    );
  }

  Row thirdRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('1');
            },
            child: const Text('1'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('2');
            },
            child: const Text('2'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('3');
            },
            child: const Text('3'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('*');
            },
            child: const Text('*'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('/');
            },
            child: const Text('/'),
          ),
        ),
      ],
    );
  }

  Row lastRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('0');
            },
            child: const Text('0'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('.');
            },
            child: const Text('.'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('00');
            },
            child: const Text('00'),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onPressed('=');
            },
            child: const Text('='),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {},
            child: const Text(''),
          ),
        ),
      ],
    );
  }
}

class ShowResultsWidget extends StatelessWidget {
  const ShowResultsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 36, 52, 59),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 30),
              Text('0', style: TextStyle(color: Colors.white, fontSize: 26)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 30),
              Text('0', style: TextStyle(color: Colors.white, fontSize: 26)),
            ],
          ),
        ],
      ),
    );
  }
}
