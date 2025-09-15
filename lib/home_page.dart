import 'package:flutter/material.dart';
import 'models/student_model.dart';
import 'student_service.dart';
import 'student_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _goToForm({Student? student, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentForm(student: student, index: index),
      ),
    ).then((_) => setState(() {}));
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

          Expanded(
            child: StudentService.students.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada data siswa",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: StudentService.students.length,
                    itemBuilder: (context, index) {
                      final s = StudentService.students[index];
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
                                  color: Color.fromARGB(255, 206, 171, 158),
                                ),
                                onPressed: () =>
                                    _goToForm(student: s, index: index),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 206, 171, 158),
                                ),
                                onPressed: () {
                                  setState(() {
                                    StudentService.deleteStudent(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
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
