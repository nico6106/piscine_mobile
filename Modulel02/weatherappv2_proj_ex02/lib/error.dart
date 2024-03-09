import 'package:flutter/material.dart';

class ErrorBodyWidget extends StatelessWidget {
  const ErrorBodyWidget({
    super.key,
    required this.title,
    required this.localisation,
    required this.isError,
  });

  final String title;
  final String localisation;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SingleChildScrollView(
          child: Text(
            localisation,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isError ? Colors.red : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
