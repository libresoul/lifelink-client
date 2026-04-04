import 'package:flutter/material.dart';
import 'package:lifelink/pages/home.dart';
import 'package:lifelink/pages/profile.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int currentindex=0;
  final List<Widget> pages = [
    Homepage(),
    Center(child: Text("Donate Page")),
    Profile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: pages[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            currentindex=index;
          });
        },
        currentIndex: currentindex,
        selectedItemColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stars_rounded),
            label: 'Donate'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'Me'
          ),
        ],
      ),
    );
  }
}
