import 'package:flutter/material.dart';

class MyBottonBarWidget extends StatelessWidget {
  const MyBottonBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: BottomAppBar(
        color: Color.fromARGB(76, 128, 175, 255),
        child: TabBar(tabs: [
          Tab(
            icon: Icon(
              Icons.watch,
              semanticLabel: 'Currently',
            ),
            text: 'Currently',
          ),
          Tab(
            icon: Icon(
              Icons.today,
              semanticLabel: 'Today',
            ),
            text: 'Today',
          ),
          Tab(
            icon: Icon(
              Icons.calendar_month,
              semanticLabel: 'Weekly',
            ),
            text: 'Weekly',
          ),
        ]),
      ),
    );
  }
}
