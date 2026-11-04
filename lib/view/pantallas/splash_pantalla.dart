import 'dart:async';

import 'package:flutter/material.dart';

class SplashPantalla extends StatefulWidget {
  const SplashPantalla({super.key});

  @override
  State<SplashPantalla> createState() => _SplashPantallaState();
}

class _SplashPantallaState extends State<SplashPantalla> {
  late final Timer _temporizador;

  @override
  void initState() {
    super.initState();
    _temporizador = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/lugares');
      }
    });
  }

  @override
  void dispose() {
    _temporizador.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(seconds: 1),
          builder: (context, valor, child) {
            return Opacity(opacity: valor, child: child);
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.travel_explore, size: 80, color: Colors.teal),
              SizedBox(height: 16),
              Text('Explora Ecuador', style: TextStyle(fontSize: 28)),
            ],
          ),
        ),
      ),
    );
  }
}
