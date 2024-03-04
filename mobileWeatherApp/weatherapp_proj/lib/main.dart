import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const MyAppBar(),
          ),
          body: const Center(
            child: TabBarView(children: [
              MyTabWidget(title: 'Currently'),
              MyTabWidget(title: 'Today'),
              MyTabWidget(title: 'Weekly'),
            ]),
          ),
          bottomNavigationBar: const MyBottonBarWidget(),
        ),
      ),
    );
  }
}

class MyTabWidget extends StatelessWidget {
  const MyTabWidget({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title),
    );
  }
}

class MyBottonBarWidget extends StatelessWidget {
  const MyBottonBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: BottomAppBar(
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

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Localisation',
              ),
            ),
          ),
          Icon(
            Icons.near_me,
            semanticLabel: 'Near me',
            size: 40.0,
          )
        ],
      ),
    );
  }
}
