import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitapos/services/api.dart';
import 'package:vitapos/main.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: LoginPage(),
    ),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Api api = Api(); // Membuat instance ApiAuth

  void _login() {
    // Mengambil nilai dari input email dan password
    String email = emailController.text;
    String password = passwordController.text;

    // Memanggil metode login dari ApiAuth
    api.login(email, password).then((response) {
      // Handle the response, e.g., extract and save the JWT token.
      String bearerToken = response['token'];

      if (bearerToken.isNotEmpty) {
        // Jika login berhasil dan token tidak kosong, arahkan ke PosPage.dart
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const MainScreen(), // Ganti dengan halaman yang sesuai
          ),
        );

        // Menyimpan token JWT ke SharedPreferences
        _saveTokenToSharedPreferences(bearerToken);
      } else {
        _showErrorDialog('Login failed. Token not found in response.');
      }
    }).catchError((error) {
      // Handle errors
      String errorMessage = 'Login failed.';

      if (error is Map<String, dynamic> && error.containsKey('message')) {
        errorMessage =
            error['message']; // Mengambil pesan dari respons API jika ada
      }

      _showErrorDialog(
          errorMessage); // Menampilkan pesan kesalahan dalam dialog
    });
  }

  void _saveTokenToSharedPreferences(String token) async {
    // Impor package SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Simpan token ke SharedPreferences dengan nama yang sesuai
    await prefs.setString('bearerToken', token);
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
