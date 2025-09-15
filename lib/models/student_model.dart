class Student {
  final String nisn;
  final String namaLengkap;
  final String jenisKelamin;
  final String agama;
  final String tempatTanggalLahir; // misal "Malang, 15 Juli 2008"
  final String noHp;
  final String nik;

  final String alamatJalan;
  final String rtRw;
  final String dusun;
  final String desa;
  final String kecamatan;
  final String kabupaten;
  final String provinsi;
  final String kodePos;

  final String namaAyah;
  final String namaIbu;
  final String namaWali;
  final String alamatOrangTua;

  final DateTime? tanggalLahir; // tambahan opsional

  Student({
    required this.nisn,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.agama,
    required this.tempatTanggalLahir,
    required this.noHp,
    required this.nik,
    required this.alamatJalan,
    required this.rtRw,
    required this.dusun,
    required this.desa,
    required this.kecamatan,
    required this.kabupaten,
    required this.provinsi,
    required this.kodePos,
    required this.namaAyah,
    required this.namaIbu,
    required this.namaWali,
    required this.alamatOrangTua,
    this.tanggalLahir,
  });

  // 🔹 Konversi ke Map (untuk form & penyimpanan)
  Map<String, dynamic> toJson() {
    return {
      'nisn': nisn,
      'namaLengkap': namaLengkap,
      'jenisKelamin': jenisKelamin,
      'agama': agama,
      'tempatTanggalLahir': tempatTanggalLahir,
      'noHp': noHp,
      'nik': nik,
      'alamatJalan': alamatJalan,
      'rtRw': rtRw,
      'dusun': dusun,
      'desa': desa,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'provinsi': provinsi,
      'kodePos': kodePos,
      'namaAyah': namaAyah,
      'namaIbu': namaIbu,
      'namaWali': namaWali,
      'alamatOrangTua': alamatOrangTua,
      'tanggalLahir': tanggalLahir?.toIso8601String(), // ✅ aman dari null
    };
  }

  // 🔹 Konversi dari Map (jika ambil dari database / json)
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      nisn: json['nisn'] ?? '',
      namaLengkap: json['namaLengkap'] ?? '',
      jenisKelamin: json['jenisKelamin'] ?? '',
      agama: json['agama'] ?? '',
      tempatTanggalLahir: json['tempatTanggalLahir'] ?? '',
      noHp: json['noHp'] ?? '',
      nik: json['nik'] ?? '',
      alamatJalan: json['alamatJalan'] ?? '',
      rtRw: json['rtRw'] ?? '',
      dusun: json['dusun'] ?? '',
      desa: json['desa'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
      kabupaten: json['kabupaten'] ?? '',
      provinsi: json['provinsi'] ?? '',
      kodePos: json['kodePos'] ?? '',
      namaAyah: json['namaAyah'] ?? '',
      namaIbu: json['namaIbu'] ?? '',
      namaWali: json['namaWali'] ?? '',
      alamatOrangTua: json['alamatOrangTua'] ?? '',
      tanggalLahir: json['tanggalLahir'] != null
          ? DateTime.tryParse(json['tanggalLahir'])
          : null,
    );
  }
}
