// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitapos/services/api.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // ListTile(
          //   leading: const Icon(Icons.shopping_cart),
          //   title: const Text('Home'),
          //   onTap: () {
          //     // Navigasi ke halaman Home dan hapus riwayat navigasi sebelumnya
          //     Navigator.pushReplacementNamed(context, '/');
          //   },
          // ),
          
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('New Sale'),
            onTap: () {
              // Navigasi ke halaman POS (Point of Sale) dan hapus riwayat navigasi sebelumnya
              Navigator.pushReplacementNamed(context, '/pos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Transactions'),
            onTap: () {
              // Navigasi ke halaman Home dan hapus riwayat navigasi sebelumnya
              Navigator.pushReplacementNamed(context, '/transactions');
            },
          ),
          ListTile(
            leading: const Icon(Icons.supervised_user_circle_outlined),
            title: const Text('Customers'),
            onTap: () {
              // Navigasi ke halaman Home dan hapus riwayat navigasi sebelumnya
              Navigator.pushReplacementNamed(context, '/customers');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Navigasi ke halaman Settings dan hapus riwayat navigasi sebelumnya
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app), // Icon logout
            title: const Text('Logout'), // Text untuk logout
            onTap: () async {
              // Panggil fungsi logout dari API Anda
              try {
                final Api api = Api();
                await api.logout();
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.remove(Api.tokenKey);
                // Navigasi kembali ke halaman login (atau halaman lain yang sesuai)
                Navigator.pushReplacementNamed(context, '/login');
              } catch (e) {
                // Tangani kesalahan jika gagal logout
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to logout: $e'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
