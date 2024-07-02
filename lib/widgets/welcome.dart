import 'dart:async';
import 'package:deloitte/widgets/home.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 4),
      () => Navigator.of(context).pushReplacement(_createRoute()),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Home(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 950),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Image.asset(
            'assets/DELBlack.jpg',
            width: 300,
            height: 120,
          ),
        ),
      ),
    );
  }
}
