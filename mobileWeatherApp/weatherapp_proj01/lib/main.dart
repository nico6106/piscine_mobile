import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainApp();
}

class _MainApp extends State<MainApp> {
  final myController = TextEditingController();
  String local = '';
  int _choice = 0;

  void setCity(String city) {
    setState(() {
      local = city;
    });
  }

  void setChoice(String choice) {
    setState(() {
      if (choice == 'city') {
        _choice = 1;
      } else if (choice == 'gps') {
        _choice = 2;
        local = 'Geolocation';
      } else {
        _choice = 0;
        local = '';
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: MyAppBar(
              myController: myController,
              setCity: setCity,
              setChoice: setChoice,
            ),
          ),
          body: TabBarView(children: [
            MyTabWidget(title: 'Currently', localisation: local),
            MyTabWidget(title: 'Today', localisation: local),
            MyTabWidget(title: 'Weekly', localisation: local),
          ]),
          bottomNavigationBar: const MyBottonBarWidget(),
        ),
      ),
    );
  }
}

class MyTabWidget extends StatelessWidget {
  const MyTabWidget(
      {super.key, required this.title, required this.localisation});

  final String title;
  final String localisation;
  // final TextEditingController myController;
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
          Text(
            localisation,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      
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
  const MyAppBar(
      {super.key,
      required this.myController,
      required this.setCity,
      required this.setChoice});

  final TextEditingController myController;
  final Function(String) setCity;
  final Function(String) setChoice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: myController,
              onChanged: (value) {
                setCity(value);
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Localisation',
                  prefixIcon: Icon(Icons.search)),
            ),
          ),
          GestureDetector(
            onTap: () => {setChoice('gps')},
            child: const Icon(
              Icons.near_me,
              semanticLabel: 'Near me',
              size: 40.0,
            ),
          )
        ],
      ),
    );
  }
}
