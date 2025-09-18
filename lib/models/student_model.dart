//TABEL DATABASE STUDENTS
class Student {
  final String? id;
  final String nisn;
  final String namaLengkap;
  final String jenisKelamin;
  final String agama;
  String? tempat;
  final String tempatTanggalLahir;
  final String noHp;
  final String nik;
  final String alamatJalan;
  final String rtRw;
  final String? wilayahId;
  final DateTime? tanggalLahir;
  final String? dusun;
  final String? desa;
  final String? kecamatan;
  final String? kabupaten;
  final String? provinsi;
  final String? kodePos;

  Student({
    this.id,
    required this.nisn,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.agama,
    this.tempat,
    required this.tempatTanggalLahir,
    required this.noHp,
    required this.nik,
    required this.alamatJalan,
    required this.rtRw,
    this.wilayahId,
    this.tanggalLahir,
    this.dusun,
    this.desa,
    this.kecamatan,
    this.kabupaten,
    this.provinsi,
    this.kodePos,
  });

  // CONVERT JSON KE STUDENT
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String?,
      nisn: json['nisn'] ?? "",
      namaLengkap: json['nama_lengkap'] ?? "",
      jenisKelamin: json['jenis_kelamin'] ?? "",
      agama: json['agama'] ?? "",
      tempat: json['tempat'] as String?,
      tempatTanggalLahir: json['tempat_tanggal_lahir'] ?? "",
      noHp: json['no_hp'] ?? "",
      nik: json['nik'] ?? "",
      alamatJalan: json['alamat_jalan'] ?? "",
      rtRw: json['rt_rw'] ?? "",
      wilayahId: json['wilayah_id'] as String?,
      tanggalLahir: json['tanggal_lahir'] != null
          ? DateTime.tryParse(json['tanggal_lahir'])
          : null,
      dusun: json['dusun'] as String?,
      desa: json['desa'] as String?,
      kecamatan: json['kecamatan'] as String?,
      kabupaten: json['kabupaten'] as String?,
      provinsi: json['provinsi'] as String?,
      kodePos: json['kode_pos']?.toString(),
    );
  }

  //CONVERT STUDENT KE JSON
  Map<String, dynamic> toJson() => {
    'nisn': nisn,
    'nama_lengkap': namaLengkap,
    'jenis_kelamin': jenisKelamin,
    'agama': agama,
    'tempat': tempat,
    'tempat_tanggal_lahir': tempatTanggalLahir,
    'no_hp': noHp,
    'nik': nik,
    'alamat_jalan': alamatJalan,
    'rt_rw': rtRw,
    'dusun': dusun,
    'desa': desa,
    'kecamatan': kecamatan,
    'kabupaten': kabupaten,
    'provinsi': provinsi,
    'kode_pos': kodePos,
    'tanggal_lahir': tanggalLahir?.toIso8601String(),
  };
}

//TABEL DATABASE ORANG TUA
class Parent {
  final String? id;
  final String? studentId;
  final String namaAyah;
  final String namaIbu;
  final String alamatOrangTua;

  Parent({
    this.id,
    this.studentId,
    required this.namaAyah,
    required this.namaIbu,
    required this.alamatOrangTua,
  });

  // CONVERT JSON KE ORANG TUA
  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'] as String?,
      studentId: json['student_id'] as String?,
      namaAyah: json['nama_ayah'] ?? "",
      namaIbu: json['nama_ibu'] ?? "",
      alamatOrangTua: json['alamat_orang_tua'] ?? "",
    );
  }

  // CONVERT ORANG TUA KE JSON
  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'nama_ayah': namaAyah,
      'nama_ibu': namaIbu,
      'alamat_orang_tua': alamatOrangTua,
    };
  }
}

//TABEL DATABASE WALI
class Guardian {
  final String? id;
  final String? studentId;
  final String namaWali;

  Guardian({this.id, this.studentId, required this.namaWali});

  //CONVERT JSON KE WALI
  factory Guardian.fromJson(Map<String, dynamic> json) {
    return Guardian(
      id: json['id'] as String?,
      studentId: json['student_id'] as String?,
      namaWali: json['nama_wali'] ?? "",
    );
  }

  //CONVERT WALI KE JSON
  Map<String, dynamic> toJson() {
    return {'student_id': studentId, 'nama_wali': namaWali};
  }
}
