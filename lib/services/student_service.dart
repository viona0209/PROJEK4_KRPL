import 'dart:io';
import 'package:projek_4/models/student_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class StudentService {
  static final _supabase = Supabase.instance.client;

//FETCH DATA SISWA
static Future<List<Student>> fetchStudents() async {
  try {
    //AMBIL DATA DARI TABLE "students"
    final response = await _supabase.from('students').select();

    //MEMASTIKAN DATA BERUPA LIST
    if (response is List) {
      print("✅ Fetched ${response.length} siswa dari Supabase");
      return response.map((e) => Student.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      print("⚠️ Response dari Supabase bukan List: $response");
      return [];
    }
  } on SocketException {
    print("⚠️ Tidak ada koneksi internet");
    throw Exception("Tidak ada koneksi internet ⚠️");
  } catch (e) {
    print("❌ Masalah koneksi dengan Supabase: $e");
    throw Exception("Masalah koneksi dengan Supabase ❌: $e");
  }
}


  //TAMBAH DATA SISWA
  static Future<void> addStudent(Student student) async {
    try {
      await _supabase.from('students').insert(student.toJson());
      print("✅ Data siswa berhasil ditambahkan: ${student.namaLengkap}");
    } on SocketException {
      print("⚠️ Tidak ada koneksi internet");
      throw Exception("Tidak ada koneksi internet ⚠️");
    } catch (e) {
      print("❌ Gagal menambah data: $e");
      throw Exception("Gagal menambah data: $e");
    }
  }

  //UPDATE DATA SISWA
  static Future<void> updateStudent(int id, Student student) async {
    try {
      await _supabase.from('students').update(student.toJson()).eq('id', id);
      print("✅ Data siswa berhasil diupdate: ${student.namaLengkap}");
    } on SocketException {
      print("⚠️ Tidak ada koneksi internet");
      throw Exception("Tidak ada koneksi internet ⚠️");
    } catch (e) {
      throw Exception("Gagal update data ❌: $e");
    }
  }

  //HAPUS DATA SISWA
  static Future<void> deleteStudent(String id) async {
    try {
      await _supabase.from('students').delete().eq('id', id);
      // tidak perlu cek response lagi ✅
    } catch (e) {
      throw Exception("❌ Error hapus siswa: $e");
    }
  }

   //AMBIL DATA DUSUN UNTUK AUTOCOMPLETE
  static Future<List<Map<String, dynamic>>> fetchDusun(String query) async {
    final data = await _supabase
        .from('wilayah')
        .select()
        .ilike('dusun', '%$query%');

    return List<Map<String, dynamic>>.from(data);
  }
}
