import 'package:flutter/material.dart';
import 'package:lifelink/pages/home.dart';
import 'package:lifelink/pages/donate.dart';
import 'package:lifelink/pages/profile.dart';
import 'dart:math' as math;

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
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _heartController;
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Home()),
        );
      }
    });
  }

  @override
  void dispose() {
    _heartController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _heartController,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE53935),
                ),
                child: const Icon(Icons.favorite, color: Colors.white, size: 40),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 12,
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, _) {
                  final t = _waveController.value;
                  final phase = t * 2 * math.pi;
                  return CustomPaint(
                    painter: _WaveBarPainter(phase),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaveBarPainter extends CustomPainter {
  final double phase;
  _WaveBarPainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final baseColor = const Color(0xFFE53935);
    final paint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final height = size.height;
    final width = size.width;
    final amplitude = height * 0.4;

    path.moveTo(0, height / 2);
    for (double x = 0; x <= width; x += 1) {
      final y = height / 2 +
          math.sin((x / width * 2 * math.pi) + phase) * amplitude;
      path.lineTo(x, y);
    }
    path
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, height),
      const Radius.circular(6),
    );
    canvas.clipRRect(rrect);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WaveBarPainter oldDelegate) =>
      oldDelegate.phase != phase;
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
    DonatePage(),
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
