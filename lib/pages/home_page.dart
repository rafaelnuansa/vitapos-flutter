import 'package:flutter/material.dart';
import 'package:vitapos/components/app_drawer.dart';
// Impor AppDrawer

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Homepage in progress',
              style: TextStyle(fontSize: 24.0),
            ),
            // Tambahkan konten Activity Report di sini
          ],
        ),
      ),
    );
  }
}
