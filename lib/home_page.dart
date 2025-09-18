import 'package:flutter/material.dart';
import 'package:projek_4/detail_page.dart';
import 'models/student_model.dart';
import 'services/student_service.dart';
import 'student_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Student>> _futureStudents;

  @override
  void initState() {
    super.initState();
    _futureStudents = _loadStudents();
  }

  //LOAD DATA SISWA
  Future<List<Student>> _loadStudents() async {
    try {
      return await StudentService.fetchStudents();
    } catch (e) {
      throw Exception("❌ Gagal konek ke server Supabase: $e");
    }
  }

  //NAVIGASI KE FORM
  void _goToForm({Student? student, String? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentForm(student: student, studentId: index),
      ),
    ).then((_) {
      setState(() {
        _futureStudents = _loadStudents();
      });
    });
  }

  //KONFIRMASI HAPUS DATA
  Future<void> _confirmDelete(Student s) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text(
          "Apakah kamu yakin ingin menghapus data ${s.namaLengkap}?",
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 118, 187, 212),
              foregroundColor: Colors.white,
            ),
            child: const Text("Hapus"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await StudentService.deleteStudent(s.id!);
        setState(() {
          _futureStudents = _loadStudents();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Data siswa berhasil dihapus")),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Gagal menghapus data: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Column(
        children: [
          //HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 118, 187, 212),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 135, 201, 226),
                  offset: const Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "📋 Data Siswa",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          //HANDLE LOADING DAN ERROR
          Expanded(
            child: FutureBuilder<List<Student>>(
              future: _futureStudents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada data siswa",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                final students = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final s = students[index];

                    //ICON BERDASAERKAN JENIS KELAMIN
                    final iconGender =
                        s.jenisKelamin.toLowerCase() == 'laki-laki'
                        ? Icons.male
                        : Icons.female;

                    final colorGender =
                        s.jenisKelamin.toLowerCase() == 'laki-laki'
                        ? const Color.fromARGB(255, 89, 166, 228)
                        : const Color.fromARGB(255, 233, 107, 149);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: const Color.fromARGB(255, 118, 187, 212),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(iconGender, color: colorGender),
                        ),
                        title: Text(
                          s.namaLengkap,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          "NISN: ${s.nisn}",
                          style: const TextStyle(color: Colors.black87),
                        ),
                        onTap: () async {
                          final parent = await StudentService.fetchParent(
                            s.id!,
                          );
                          final guardian = await StudentService.fetchGuardian(
                            s.id!,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StudentDetailPage(
                                student: s,
                                parent: parent,
                                guardian: guardian,
                              ),
                            ),
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () =>
                                  _goToForm(student: s, index: s.id),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () => _confirmDelete(s),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      //TOMBOL TAMBAH
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 118, 187, 212),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Tambah", style: TextStyle(color: Colors.white)),
        onPressed: () => _goToForm(),
      ),
    );
  }
}
