import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitapos/services/api.dart';

// Membuat Provider untuk mengambil data pelanggan dari API
final customerProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final api = Api();
  final customers = await api.fetchCustomers();
  return customers;
});

// Define a custom provider to manage the selected customer using SharedPreferences
final selectedCustomerProvider = Provider<String?>((ref) {
  // Load the selected customer from SharedPreferences
  final prefs = ref.watch(prefsProvider);
  return prefs.getString('selected_customer');
});

// Define a provider for SharedPreferences
final prefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // Replace this with your code to obtain SharedPreferences
});
