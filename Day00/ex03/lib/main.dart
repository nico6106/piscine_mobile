import 'dart:ffi';

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
  String expression = '0';
  String calculs = '0';
  List<String> elems = [];

  void _showKey(String text) {
    setState(() {
      print('button press :$text');
      if (text == 'AC') {
        elems.clear();
        calculs = '0';
        // return ;
      } else if (text == 'C') {
        if (elems.isNotEmpty) {
          elems.removeLast();
        }
      } else if (text == '=') {
        try {
          final List exp = parseExpression(elems);
          final bool correct = evaluateExpression(exp);
          if (!correct) {
            calculs = 'Incorrect expression';
            return;
          }
          final List expNeg = handleNegatives(exp);
          final double result = computeNumber(expNeg);
          calculs = result.toString();
        } catch (e) {
          calculs = e.toString();
        }
      } else {
        elems.add(text);
      }
      expression = converToString(elems);
    });
  }

  List handleNegatives(List exp) {
    List newExp = [];
    bool isPrevOperator = false;
    bool applyNegative = false;

    //handle negative for first elem
    if (exp.length >= 2 && exp[0] is String && exp[0] == '-') {
      if (exp[1] is double) {
        exp[0] = exp[1] * -1;
        exp.removeAt(1);
      }
    }
    for (dynamic elem in exp) {
      if (elem is double || elem is int || elem is Float) {
        // si chiffre, vérification si on doit mettre un négatif
        if (applyNegative == false) {
          newExp.add(elem);
        } else {
          newExp.add(elem * -1);
        }
        isPrevOperator = false;
        applyNegative = false;
      } else if (elem is String) {
        // si opérateur: 1er=ajout opérateur, 2nd =
        if (isPrevOperator) {
          applyNegative = true;
        } else {
          newExp.add(elem);
        }
        isPrevOperator = true;
      }
    }
    return newExp;
  }

  String converToString(List<String> elems) {
    String exp = "";
    if (elems.isEmpty) {
      return '0';
    }
    for (String elem in elems) {
      exp = exp + elem;
    }
    return exp;
  }

  List parseExpression(List<String> elems) {
    List exp = [];
    String currExp = "";
    double number = 0.0;

    for (String elem in elems) {
      if ((elem.compareTo('0') >= 0 && elem.compareTo('9') <= 0) ||
          elem == '.') {
        currExp = currExp + elem;
      } else {
        if (currExp != '') {
          if (double.tryParse(currExp) == null) {
            throw 'Error with number';
          }
          number = double.parse(currExp);
          exp.add(number);
        }
        exp.add(elem);
        currExp = "";
      }
    }

    // add last number
    if (currExp != "") {
      if (double.tryParse(currExp) == null) {
        throw 'Error with number';
      }
      number = double.parse(currExp);
      exp.add(number);
      currExp = "";
    }
    return exp;
  }

  bool evaluateExpression(List elems) {
    int nbPrevOperator = 0;
    if (elems.isNotEmpty && elems[0] is String && elems[0] != '-') {
      return false;
    }
    for (dynamic elem in elems) {
      if (elem is double) {
        nbPrevOperator = 0;
      } else if (elem is String) {
        if (nbPrevOperator >= 2) {
          return false;
        } else if (nbPrevOperator == 1 && elem != '-') {
          return false;
        }
        nbPrevOperator++;
      }
    }
    if (elems.lastOrNull is! double) {
      return false;
    }
    return true;
  }

  double computeNumber(List exp) {
    double calc = 0.0;
    dynamic elem = "";

    // first run: identity priority operations (* and /)
    for (int i = 0; i < exp.length; i++) {
      elem = exp[i];
      print('firstrun: elem=$elem, exp=$exp');
      if (elem is String && elem == '*') {
        calc = exp[i - 1] * exp[i + 1];
        exp[i - 1] = calc;
        exp.removeAt(i + 1);
        exp.removeAt(i);
        i--;
      } else if (elem is String && elem == '/') {
        if (exp[i + 1] == 0) {
          throw 'Division by 0';
        }
        calc = exp[i - 1] / exp[i + 1];
        exp[i - 1] = calc;
        exp.removeAt(i + 1);
        exp.removeAt(i);
        i--;
      }
    }
    print('END firstrun: exp=$exp');

    // second run: compute all calcs
    if (exp.length == 1) {
      return exp[0];
    }
    for (int i = 0; i < exp.length; i++) {
      elem = exp[i];
      // print('secondrun: elem=$elem, exp=$exp');
      if (elem is String && elem == '+') {
        calc = exp[i - 1] + exp[i + 1];
        exp[i - 1] = calc;
        exp.removeAt(i + 1);
        exp.removeAt(i);
        i--;
      } else if (elem is String && elem == '-') {
        calc = exp[i - 1] - exp[i + 1];
        exp[i - 1] = calc;
        exp.removeAt(i + 1);
        exp.removeAt(i);
        i--;
      }
    }
    if (exp[0] is double) {
      return exp[0];
    }
    return (0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ShowResultsWidget(
            expUser: expression,
            result: calculs,
          ),
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
      child: Column(
        children: [
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
        ],
      ),
    );
  }

  Widget drawRow(
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
              child: Text(
                text[i],
                style: TextStyle(
                  color: (colors[i] == 'grey'
                      ? const Color.fromARGB(255, 36, 52, 59)
                      : (colors[i] == 'white' ? Colors.white : Colors.red)),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class ShowResultsWidget extends StatelessWidget {
  const ShowResultsWidget(
      {super.key, required this.expUser, required this.result});

  final String expUser;
  final String result;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 36, 52, 59),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    expUser,
                    style: const TextStyle(color: Colors.white, fontSize: 26),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  result,
                  style: const TextStyle(color: Colors.white, fontSize: 26),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
