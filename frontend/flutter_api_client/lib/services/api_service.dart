import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Timeout cepat untuk percobaan pertama (5 detik)
  static const Duration _timeoutLocal = Duration(seconds: 5);
  static const Duration _timeoutRailway = Duration(seconds: 15);

  // Base URL untuk mode debug (lokal) — otomatis deteksi platform
  String get _localBaseUrl {
    try {
      if (!kIsWeb && Platform.isAndroid) {
        return 'http://10.0.2.2:8000';
      }
    } catch (_) {
      // Bukan platform Android atau sedang di web
    }
    return 'http://localhost:8000';
  }

  // Base URL production (Railway)
  static const String _railwayBaseUrl =
      'https://web-lanjut-production.up.railway.app';

  Future<List<Product>> getProducts() async {
    // Mode Release: langsung pakai Railway
    if (kReleaseMode) {
      return _fetchProducts(_railwayBaseUrl, _timeoutRailway);
    }

    // Mode Debug: coba lokal dulu, fallback ke Railway kalau gagal
    try {
      return await _fetchProducts(_localBaseUrl, _timeoutLocal);
    } catch (e) {
      // Gagal ke lokal, fallback ke Railway
      print('Fallback ke Railway... (lokal gagal: $e)');
      try {
        return await _fetchProducts(_railwayBaseUrl, _timeoutRailway);
      } catch (e2) {
        // Dua-duanya gagal
        throw Exception(
          'Gagal mengambil data. Coba periksa:\n'
          '1. Pastikan backend lokal berjalan (python -m uvicorn...)\n'
          '2. Atau pastikan koneksi internet untuk akses Railway\n'
          'Pesan error: $e2',
        );
      }
    }
  }

  Future<List<Product>> _fetchProducts(
    String baseUrl,
    Duration timeout,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/products'),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> products = jsonData['data'];

        return products
            .map((item) => Product.fromJson(item))
            .toList();
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Timeout setelah ${timeout.inSeconds} detik');
    }
  }
}