import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final String baseUrl = 'https://backoffice.rafaelnuansa.my.id/api';
  // final String baseUrl = 'http://192.168.137.1/api';

  // Kunci untuk menyimpan bearer token di SharedPreferences
  static const String tokenKey = 'bearerToken';

  // Metode untuk mendapatkan bearer token dari SharedPreferences
  Future<String?> getBearerToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Metode untuk menyimpan bearer token ke SharedPreferences
  Future<void> saveBearerToken(String bearerToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, bearerToken);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Ambil bearer token dari respons
      final String bearerToken = responseData['token'];

      // Simpan bearer token ke SharedPreferences
      await saveBearerToken(bearerToken);

      // Validasi token ke server
      final bool isTokenValid = await validateTokenOnServer(bearerToken);

      if (isTokenValid) {
        // Jika token valid, kembalikan respons seperti biasa
        return responseData;
      } else {
        throw Exception('Token is not valid');
      }
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<bool> validateTokenOnServer(String bearerToken) async {
    try {
      // Kirim token ke server untuk divalidasi
      final response = await http.post(
        Uri.parse(
            '$baseUrl/validate-token'), // Ganti dengan endpoint validasi token di server Anda
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken', // Sertakan token dalam header
        },
      );

      if (response.statusCode == 200) {
        // Token valid, kembalikan true
        return true;
      } else if (response.statusCode == 401) {
        // Token tidak valid, kembalikan false
        return false;
      } else {
        // Tangani kondisi lain sesuai kebutuhan Anda
        throw Exception('Token validation failed');
      }
    } catch (error) {
      // Tangani kesalahan jaringan atau kesalahan lainnya
      throw Exception(error);
    }
  }

  Future<void> logout() async {
    final String? bearerToken = await getBearerToken();
    if (bearerToken != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken', // Sertakan token dalam header
        },
      );

      if (response.statusCode == 200) {
        // Logout berhasil, Anda dapat menghapus token dari penyimpanan lokal (jika digunakan)
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(tokenKey);
      } else {
        throw Exception('Failed to logout');
      }
    }
  }

  Future<Map<String, dynamic>> fetchProducts() async {
    final url = Uri.parse('$baseUrl/products');

    try {
      final String? bearerToken = await getBearerToken();

      if (bearerToken == null) {
        // Tangani jika bearer token tidak tersedia
        throw Exception('Bearer token is not available');
      }

      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
      );

      if (response.statusCode == 200) {
        // Parsing data JSON dari respons HTTP
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        // Handle kesalahan jika respons HTTP tidak berhasil
        throw Exception('Gagal memuat data produk: ${response.statusCode}');
      }
    } catch (e) {
      // Handle kesalahan jaringan atau lainnya
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCustomers() async {
    final url = Uri.parse('$baseUrl/customers');

    try {
      final String? bearerToken = await getBearerToken();

      if (bearerToken == null) {
        // Tangani jika bearer token tidak tersedia
        throw Exception('Bearer token is not available');
      }

      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
      );

      if (response.statusCode == 200) {
        // Parsing data JSON dari respons HTTP
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> customers =
            data['customers'].cast<Map<String, dynamic>>();
        return customers;
      } else {
        // Handle kesalahan jika respons HTTP tidak berhasil
        throw Exception('Gagal memuat data pelanggan: ${response.statusCode}');
      }
    } catch (e) {
      // Handle kesalahan jaringan atau lainnya
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<Map<String, dynamic>> createTransaction(
      Map<String, dynamic> transactionData) async {
    final url = Uri.parse('$baseUrl/transactions');

    try {
      final String? bearerToken = await getBearerToken();

      if (bearerToken == null) {
        // Tangani jika bearer token tidak tersedia
        throw Exception('Bearer token is not available');
      }

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode(transactionData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to create transaction');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> createCustomer(
      Map<String, dynamic> customerData) async {
    final url = Uri.parse('$baseUrl/customers');

    try {
      final String? bearerToken = await getBearerToken();

      if (bearerToken == null) {
        // Tangani jika bearer token tidak tersedia
        throw Exception('Bearer token is not available');
      }

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode(customerData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to create customer');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

Future<List<Map<String, dynamic>>> getTransactions() async {
  try {
    final String? bearerToken = await getBearerToken();

    if (bearerToken == null) {
      // Handle the case where the bearer token is not available
      throw Exception('Bearer token is not available');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/transactions'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> transactionList = List<Map<String, dynamic>>.from(json.decode(response.body));
      return transactionList;
    } else {
      // Handle errors if the HTTP response is not successful
      throw Exception('Failed to fetch transactions: ${response.statusCode}');
    }
  } catch (e) {
    // Handle network or other errors
    throw Exception('An error occurred: $e');
  }
}



}
