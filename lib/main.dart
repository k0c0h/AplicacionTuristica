import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/turismo_viewmodel.dart';
import 'view/pantallas/splash_pantalla.dart';
import 'view/pantallas/lugares_pantalla.dart';
import 'view/pantallas/detalle_pantalla.dart';

void main() {
  runApp( const AplicacionTuristicaApp());
}

class AplicacionTuristicaApp extends StatelessWidget {
  const AplicacionTuristicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TurismoViewModel(),
      child: MaterialApp(
        title: 'Aplicación Turística',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor:  Color(0xFF0284C7),
            primary:  Color(0xFF0284C7),
            secondary:  Color(0xFFF97316),
          ),
          scaffoldBackgroundColor:  Color(0xFFF8FAFC),
          appBarTheme:  AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) =>  SplashPantalla(),
          '/lugares': (context) =>  LugaresPantalla(),
          DetallePantalla.routeName: (context) =>  DetallePantalla(),
        },
      ),
    );
  }
}
