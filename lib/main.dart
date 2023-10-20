// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitapos/pages/customer_page.dart';
import 'package:vitapos/pages/held_transactions_page.dart';
import 'package:vitapos/pages/login_page.dart';
import 'package:vitapos/pages/pos_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitapos/pages/setting_page.dart';
import 'package:vitapos/pages/transaction_page.dart';
import 'package:vitapos/services/api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/pos': (context) => const PosPage(),
        '/login': (context) => const LoginPage(),
        '/customers': (context) => const CustomerPage(),
        '/held_transactions': (context) => const HeldTransactionsPage(),
        '/transactions': (context) => const TransactionPage(),
        '/settings': (context) => const SettingPage(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  // Add a method to check if a bearer token exists in SharedPreferences
  Future<void> checkBearerToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bearerToken = prefs.getString('bearerToken');

    if (bearerToken == null) {
      // If the bearer token is not found, navigate to the login page
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      // Token ditemukan, validasi token ke server
      final Api api = Api();
      final bool isTokenValid = await api.validateTokenOnServer(bearerToken);

      if (!isTokenValid) {
        // Token tidak valid, navigate to the login page
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkBearerToken();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PosPage(),
    );
  }
}
