import 'dart:io';
import 'package:projek_4/models/student_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentService {
  static final _supabase = Supabase.instance.client;

  // FETCH DATA SISWA
  static Future<List<Student>> fetchStudents() async {
    try {
      final response = await _supabase.from('students').select();
      if (response is List) {
        print("✅ Fetched ${response.length} siswa dari Supabase");
        return response
            .map((e) => Student.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        print("⚠️ Response dari Supabase bukan List: $response");
        return [];
      }
    } on SocketException {
      throw Exception("Tidak ada koneksi internet ⚠️");
    } catch (e) {
      throw Exception("Masalah koneksi dengan Supabase ❌: $e");
    }
  }

  // AMBIL DATA SISWA DETAIL
  static Future<Map<String, dynamic>> fetchStudentDetail(
    String studentId,
  ) async {
    try {
      final response = await _supabase
          .from('students')
          .select('*, dusun, desa, kecamatan, kabupaten, provinsi, kode_pos')
          .eq('id', studentId)
          .single();

      if (response == null) throw Exception("Data siswa tidak ditemukan");
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Gagal ambil data detail siswa ❌: $e");
    }
  }

  // TAMBAH DATA SISWA + ORANG TUA + WALI
  static Future<void> addStudentFull({
    required Student student,
    required Parent parent,
    required Guardian guardian,
  }) async {
    try {
      // INSERT SISWA
      final response = await _supabase
          .from('students')
          .insert(student.toJson())
          .select()
          .single();

      final studentId = response['id'] as String;

      // INSERT ORANG TUA
      await _supabase.from('parents').insert({
        'student_id': studentId,
        'nama_ayah': parent.namaAyah,
        'nama_ibu': parent.namaIbu,
        'alamat_orang_tua': parent.alamatOrangTua,
      });

      // INSERT WALI
      await _supabase.from('guardians').insert({
        'student_id': studentId,
        'nama_wali': guardian.namaWali,
      });

      print('✅ Siswa, orang tua, dan wali berhasil ditambahkan!');
    } on SocketException {
      throw Exception("Tidak ada koneksi internet ⚠️");
    } catch (e) {
      throw Exception("Gagal menambah data: $e");
    }
  }

  // UPDATE DATA SISWA
  static Future<void> updateStudent(String id, Student student) async {
    try {
      await _supabase.from('students').update(student.toJson()).eq('id', id);
      print("✅ Data siswa berhasil diupdate: ${student.namaLengkap}");
    } on SocketException {
      throw Exception("Tidak ada koneksi internet ⚠️");
    } catch (e) {
      throw Exception("Gagal update data ❌: $e");
    }
  }

  // UPDATE DATA SISWA + ORANG TUA + WALI
  static Future<void> updateStudentFull({
    required String studentId,
    required Student student,
    required Parent parent,
    required Guardian guardian,
  }) async {
    try {
      // UPDATE STUDENT
      await _supabase
          .from('students')
          .update(student.toJson())
          .eq('id', studentId);

      // UPDATE ORANG TUA
      await _supabase
          .from('parents')
          .update(parent.toJson())
          .eq('student_id', studentId);

      // UPDATE WALI
      await _supabase
          .from('guardians')
          .update(guardian.toJson())
          .eq('student_id', studentId);

      print('✅ Data siswa, orang tua, dan wali berhasil diupdate!');
    } on SocketException {
      throw Exception("Tidak ada koneksi internet ⚠️");
    } catch (e) {
      throw Exception("Gagal update data full ❌: $e");
    }
  }

  // HAPUS DATA SISWA
  static Future<void> deleteStudent(String id) async {
    try {
      await _supabase.from('students').delete().eq('id', id);
    } catch (e) {
      throw Exception("❌ Error hapus siswa: $e");
    }
  }

  // AMBIL DATA ORANG TUA BERDASARKAN studentId
  static Future<Parent> fetchParent(String studentId) async {
    try {
      final response = await _supabase
          .from('parents')
          .select()
          .eq('student_id', studentId)
          .single();

      if (response == null) throw Exception("Data orang tua tidak ditemukan");
      return Parent.fromJson(response as Map<String, dynamic>);
    } on SocketException {
      throw Exception("Tidak ada koneksi internet ⚠️");
    } catch (e) {
      throw Exception("Gagal ambil data orang tua ❌: $e");
    }
  }

  // AMBIL DATA WALI BERDASARKAN studentId
  static Future<Guardian> fetchGuardian(String studentId) async {
    try {
      final response = await _supabase
          .from('guardians')
          .select()
          .eq('student_id', studentId)
          .single();

      if (response == null) throw Exception("Data wali tidak ditemukan");
      return Guardian.fromJson(response as Map<String, dynamic>);
    } on SocketException {
      throw Exception("Tidak ada koneksi internet ⚠️");
    } catch (e) {
      throw Exception("Gagal ambil data wali ❌: $e");
    }
  }

  // AMBIL DATA DUSUN UNTUK AUTOCOMPLETE
  static Future<List<Map<String, dynamic>>> fetchDusun(String query) async {
    final data = await _supabase
        .from('wilayah')
        .select()
        .ilike('dusun', '%$query%');

    return List<Map<String, dynamic>>.from(data);
  }
}
