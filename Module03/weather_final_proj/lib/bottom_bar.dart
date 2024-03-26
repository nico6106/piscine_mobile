import 'package:flutter/material.dart';

class MyBottonBarWidget extends StatelessWidget {
  const MyBottonBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: BottomAppBar(
        color: Color.fromRGBO(34, 26, 101, 1),
        // color: Colors.transparent,
        child: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: [
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
          ],
        ),
      ),
    );
  }
}
