import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  // Fungsi untuk login pengguna.
  Future<void> login(String email, String password) async {
    // Implementasikan logika otentikasi di sini.
    // Misalnya, Anda dapat melakukan permintaan HTTP ke server untuk memeriksa kredensial.
    // Jika otentikasi berhasil, atur _isAuthenticated menjadi true.
    if (email == 'user@example.com' && password == 'password') {
      _isAuthenticated = true;
      notifyListeners(); // Memberi tahu perubahan status otentikasi.
    } else {
      throw Exception('Login failed'); // Atau tangani kesalahan login di sini.
    }
  }

  // Fungsi untuk logout pengguna.
  Future<void> logout() async {
    // Implementasikan logika logout di sini.
    // Misalnya, menghapus token otentikasi atau membersihkan sesi.
    _isAuthenticated = false;
    notifyListeners(); // Memberi tahu perubahan status otentikasi.
  }
}
