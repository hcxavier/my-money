import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:my_money/pages/auth_check.dart';
import 'package:my_money/pages/home.dart';
import 'package:my_money/pages/login.dart';
import 'package:my_money/pages/profile.dart';
import 'package:my_money/pages/register.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configuração de rotas do app
      initialRoute: "/",
      routes: {
        "/": (context) => const AuthCheck(),
        "/home": (context) => const HomePage(),
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/profile": (context) => const ProfilePage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'My Money',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(
          0xFF121214,
        ), // Fundo escuro principal
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00875F), // Verde principal
          secondary: Color(0xFF00B37E), // Verde claro
          surface: Color(0xFF202024), // Fundo dos cards
        ),
      ),
    );
  }
}
