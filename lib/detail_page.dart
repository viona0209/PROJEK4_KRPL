import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/student_model.dart';

class StudentDetailPage extends StatelessWidget {
  final Student student;
  final Parent parent;
  final Guardian guardian;

  const StudentDetailPage({
    super.key,
    required this.student,
    required this.parent,
    required this.guardian,
  });

  String formatTanggal(DateTime? tanggal) {
    if (tanggal == null) return "-";
    return DateFormat("dd-MM-yyyy").format(tanggal);
  }

  Widget buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              (value != null && value.isNotEmpty) ? value : "-",
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 118, 187, 212),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 118, 187, 212),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                const Text(
                  "Detail Siswa",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildSection("Data Diri", [
                    buildRow("NISN", student.nisn),
                    buildRow("Nama Lengkap", student.namaLengkap),
                    buildRow("Jenis Kelamin", student.jenisKelamin),
                    buildRow("Agama", student.agama),
                    buildRow(
                      "Tempat, Tanggal Lahir",
                      "${student.tempat ?? '-'}, ${formatTanggal(student.tanggalLahir)}",
                    ),
                    buildRow("No HP", student.noHp),
                    buildRow("NIK", student.nik),
                  ]),
                  buildSection("Alamat", [
                    buildRow("Jalan", student.alamatJalan),
                    buildRow("RT/RW", student.rtRw),
                    buildRow("Dusun", student.dusun),
                    buildRow("Desa", student.desa),
                    buildRow("Kecamatan", student.kecamatan),
                    buildRow("Kabupaten", student.kabupaten),
                    buildRow("Provinsi", student.provinsi),
                    buildRow("Kode Pos", student.kodePos),
                  ]),
                  buildSection("Orang Tua & Wali", [
                    buildRow("Nama Ayah", parent.namaAyah),
                    buildRow("Nama Ibu", parent.namaIbu),
                    buildRow("Alamat Orang Tua", parent.alamatOrangTua),
                    buildRow("Nama Wali", guardian.namaWali),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
