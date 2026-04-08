import 'package:flutter/material.dart';
import 'package:lifelink/core/storage/session_store.dart';
import 'package:lifelink/screens/home/app_shell.dart';
import 'package:lifelink/screens/onboarding/welcome.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeGate());
  }
}

class HomeGate extends StatelessWidget {
  HomeGate({super.key});

  final _sessionStore = SessionStore();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _sessionStore.hasSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return const AppShell();
        }

        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.08,
              vertical: MediaQuery.of(context).size.height * 0.06,
            ),
            child: const Welcome(),
          ),
        );
      },
    );
  }
}
