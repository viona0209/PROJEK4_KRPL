class Student {
  final String? id;
  final String nisn;
  final String namaLengkap;
  final String jenisKelamin;
  final String agama;
  final String tempatTanggalLahir;
  final String noHp;
  final String nik;
  final String alamatJalan;
  final String rtRw;
  final String dusun;
  final String desa;
  final String kecamatan;
  final String kabupaten;
  final String kodePos;
  final String namaAyah;
  final String namaIbu;
  final String namaWali;
  final String alamatOrangTua;
  final DateTime? tanggalLahir;

//KONSTRUKTOR UTAMA
  Student({
    this.id,
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
    required this.kodePos,
    required this.namaAyah,
    required this.namaIbu,
    required this.namaWali,
    required this.alamatOrangTua,
    this.tanggalLahir,
  });

//KONVERSI DARI JSON KE OBJECT
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      nisn: json['nisn'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      agama: json['agama'] ?? '',
      tempatTanggalLahir: json['tempat_tanggal_lahir'] ?? '',
      noHp: json['no_hp'] ?? '',
      nik: json['nik'] ?? '',
      alamatJalan: json['alamat_jalan'] ?? '',
      rtRw: json['rt_rw'] ?? '',
      dusun: json['dusun'] ?? '',
      desa: json['desa'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
      kabupaten: json['kabupaten'] ?? '',
      kodePos: json['kode_pos'] ?? '',
      namaAyah: json['nama_ayah'] ?? '',
      namaIbu: json['nama_ibu'] ?? '',
      namaWali: json['nama_wali'] ?? '',
      alamatOrangTua: json['alamat_orang_tua'] ?? '',
      tanggalLahir: json['tanggal_lahir'] != null
          ? DateTime.tryParse(json['tanggal_lahir'])
          : null,
    );
  }

//KONVERSI DARI OBJECT KE JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nisn': nisn,
      'nama_lengkap': namaLengkap,
      'jenis_kelamin': jenisKelamin,
      'agama': agama,
      'tempat_tanggal_lahir': tempatTanggalLahir,
      'no_hp': noHp,
      'nik': nik,
      'alamat_jalan': alamatJalan,
      'rt_rw': rtRw,
      'dusun': dusun,
      'desa': desa,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'kode_pos': kodePos,
      'nama_ayah': namaAyah,
      'nama_ibu': namaIbu,
      'nama_wali': namaWali,
      'alamat_orang_tua': alamatOrangTua,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
    };
  }
}
