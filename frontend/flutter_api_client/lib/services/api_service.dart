import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Gunakan http:// (bukan https://)
  // Ganti 127.0.0.1 ke 10.0.2.2 jika menggunakan Emulator Android
  final String baseUrl = 'http://10.0.2.2:8000';

  Future<List<Product>> getProducts() async {
    try {
      // 1. Tambahkan blok try
      final response = await http.get(
        Uri.parse('$baseUrl/api/products'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> products = jsonData['data'];

        return products
            .map((item) => Product.fromJson(item))
            .toList();
} else {
        throw Exception('Gagal mengambil data');
      }
    } catch (error) {
      // 3. catch sekarang memiliki pasangan try
      throw Exception('Terjadi kesalahan: $error');
    }
  }
}