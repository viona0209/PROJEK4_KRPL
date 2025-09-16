import 'package:supabase_flutter/supabase_flutter.dart';

class WilayahService {
  static final _supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchDusun() async {
    final response = await _supabase.from('wilayah').select();
    return List<Map<String, dynamic>>.from(response);
  }
}
