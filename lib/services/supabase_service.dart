import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  //AMBIL DATA WILAYAH
  Future<List<Map<String, dynamic>>> fetchWilayah() async {
    //CEK KONEKSI INTERNET
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      throw Exception("Tidak ada koneksi internet. Periksa jaringan Anda.");
    }

    try {
      final response = await _supabase.from("wilayah").select();

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception("Gagal koneksi dengan Supabase: $e");
    }
  }
}
