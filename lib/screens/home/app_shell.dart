import 'package:flutter/material.dart';
import 'package:lifelink/pages/home.dart';
import 'package:lifelink/pages/profile.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentindex = 0;

  final List<Widget> pages = const [
    Homepage(),
    Center(child: Text('Donate Page')),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentindex = index;
          });
        },
        currentIndex: currentindex,
        selectedItemColor: Colors.red,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.stars_rounded),
            label: 'Donate',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: 'Me'),
        ],
      ),
    );
  }
}
