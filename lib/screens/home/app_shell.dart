import 'package:flutter/material.dart';
import 'package:lifelink/pages/home.dart';
import 'package:lifelink/pages/profile.dart';
import 'package:lifelink/pages/donate.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentindex = 0;

  final List<Widget> pages = const [
    Homepage(),
    // DonatePage is a separate screen; show it when Donate tab is tapped.
    // We'll import it lazily in case the page depends on other things.
    // Placeholder kept to preserve const list shape; actual widget is replaced in build.
    SizedBox.shrink(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    final body = currentindex == 1 ? const DonatePage() : pages[currentindex];

    return Scaffold(
      body: body,
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
