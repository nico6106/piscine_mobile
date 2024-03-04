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
        Expanded(
            child: drawRow(['7', '8', '9', 'C', 'AC'],
                ['grey', 'grey', 'grey', 'red', 'red'])),
        Expanded(
            child: drawRow(['4', '5', '6', '+', '-'],
                ['grey', 'grey', 'grey', 'white', 'white'])),
        Expanded(
            child: drawRow(['1', '2', '3', '*', '/'],
                ['grey', 'grey', 'grey', 'white', 'white'])),
        Expanded(
            child: drawRow(['0', '.', '00', '=', ''],
                ['grey', 'grey', 'grey', 'white', 'white'])),
      ]),
    );
  }

  Row drawRow(
    List<String> text,
    List<String> colors,
  ) {
    return Row(
      children: <Widget>[
        for (var i = 0; i < text.length; i++)
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (text[i] != '') {
                  onPressed(text[i]);
                }
              },
              child: Text(text[i],
                  style: TextStyle(
                    color: (colors[i] == 'grey'
                        ? const Color.fromARGB(255, 36, 52, 59)
                        : (colors[i] == 'white' ? Colors.white : Colors.red)),
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center),
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
      color: const Color.fromARGB(255, 36, 52, 59),
      constraints: const BoxConstraints(minHeight: 80),
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
