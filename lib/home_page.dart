import 'package:flutter/material.dart';
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

  //KOAD DATA STUDENTS DARI SUPABASE
  Future<List<Student>> _loadStudents() async {
    try {
      return await StudentService.fetchStudents();
    } catch (e) {
      throw Exception("❌ Gagal konek ke server Supabase: $e");
    }
  }

  //NAVIGASI KE FORM TAMBAH / EDIT
  void _goToForm({Student? student}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentForm(
          student: student,
          index: null,
        ),
      ),
    ).then((_) {
      setState(() {
        _futureStudents = _loadStudents(); //REFRESH LIST
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Column(
        children: [
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
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.brown[100],
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: const Color.fromARGB(255, 118, 187, 212),
                              ),
                              onPressed: () => _goToForm(student: s),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: const Color.fromARGB(255, 118, 187, 212),
                              ),
                              onPressed: () async {
                                try {
                                  await StudentService.deleteStudent(s.id!);
                                  setState(() {
                                    _futureStudents = _loadStudents();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Data siswa berhasil dihapus ✅",
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Gagal menghapus: $e"),
                                    ),
                                  );
                                }
                              },
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 118, 187, 212),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Tambah", style: TextStyle(color: Colors.white)),
        onPressed: () => _goToForm(),
      ),
    );
  }
}
