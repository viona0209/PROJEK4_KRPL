import 'package:flutter/material.dart';
import 'models/student_model.dart';
import 'services/student_service.dart';
import 'services/wilayah_service.dart';

class StudentForm extends StatefulWidget {
  final Student? student;
  final int? index;

  const StudentForm({super.key, this.student, this.index});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  int _currentStep = 0;

  //FORM KEY TIAP STEP
  final _formKeys = [
    GlobalKey<FormState>(), //STEP 0:DATA DIRI
    GlobalKey<FormState>(), // STEP 1: ALAMAT
    GlobalKey<FormState>(), // STEP 2: ORANG TUA
  ];

  final Map<String, TextEditingController> _controllers = {};
  String? _jenisKelamin;
  String? _agama;
  DateTime? _tanggalLahir;

  @override
  void initState() {
    super.initState();
    final fields = [
      'nisn',
      'namaLengkap',
      'noHp',
      'nik',
      'alamatJalan',
      'rtRw',
      'dusun',
      'desa',
      'kecamatan',
      'kabupaten',
      'kode_pos',
      'namaAyah',
      'namaIbu',
      'namaWali',
      'alamatOrangTua',
    ];
    for (var f in fields) {
      _controllers[f] = TextEditingController(
        text: widget.student != null ? widget.student!.toJson()[f] ?? '' : '',
      );
    }

    _jenisKelamin = widget.student?.jenisKelamin;
    _agama = widget.student?.agama;
    if (widget.student?.tempatTanggalLahir != null &&
        widget.student!.tempatTanggalLahir.isNotEmpty) {
      _tanggalLahir = DateTime.tryParse(widget.student!.tempatTanggalLahir);
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _pickTanggalLahir() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime(2005),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _tanggalLahir = picked);
    }
  }

  //MENYIMPAN DATA KE DATABASE
  Future<void> _save() async {
    final student = Student(
      nisn: _controllers['nisn']!.text,
      namaLengkap: _controllers['namaLengkap']!.text,
      jenisKelamin: _jenisKelamin ?? '',
      agama: _agama ?? '',
      tempatTanggalLahir: _tanggalLahir != null
          ? _tanggalLahir!.toIso8601String()
          : '',
      noHp: _controllers['noHp']!.text,
      nik: _controllers['nik']!.text,

      // alamat
      alamatJalan: _controllers['alamatJalan']!.text,
      rtRw: _controllers['rtRw']!.text,
      dusun: _controllers['dusun']!.text,
      desa: _controllers['desa']!.text,
      kecamatan: _controllers['kecamatan']!.text,
      kabupaten: _controllers['kabupaten']!.text,
      kodePos: _controllers['kode_pos']!.text,

      // orang tua
      namaAyah: _controllers['namaAyah']!.text,
      namaIbu: _controllers['namaIbu']!.text,
      namaWali: _controllers['namaWali']!.text,
      alamatOrangTua: _controllers['alamatOrangTua']!.text,

      // opsional
      tanggalLahir: _tanggalLahir,
    );

    try {
      //CEK APKAH MENAMBAH DATA BARU ATAU UPDATE DATA
      if (widget.index == null) {
        await StudentService.addStudent(student);
      } else {
        await StudentService.updateStudent(widget.index!, student);
      }

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Data berhasil disimpan")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Gagal simpan data: $e")));
    }
  }

  //FIELD UMUM
  Widget buildField(
    String key, {
    String? hint,
    TextInputType? keyboard,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: _controllers[key],
        keyboardType: keyboard,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: key,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: const Color.fromARGB(255, 118, 187, 212),
        ),
        validator: (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

  //DROPDOWN UMUM
  Widget buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: const Color.fromARGB(255, 118, 187, 212),
        ),
        validator: (v) => v == null ? "Wajib dipilih" : null,
      ),
    );
  }

  //AUTOCOMPLETE DUSUN
  Widget buildDusunField() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: WilayahService.fetchDusun(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final dusunList = snapshot.data!;
        return Autocomplete<Map<String, dynamic>>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<Map<String, dynamic>>.empty();
            }
            return dusunList.where(
              (dusun) => dusun['dusun'].toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              ),
            );
          },
          displayStringForOption: (dusun) => dusun['dusun'],
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            _controllers['dusun'] = controller;
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: "Dusun",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 118, 187, 212),
              ),
              validator: (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
            );
          },
          onSelected: (dusun) {
            setState(() {
              _controllers['dusun']!.text = dusun['dusun'];
              _controllers['desa']!.text = dusun['desa'];
              _controllers['kecamatan']!.text = dusun['kecamatan'];
              _controllers['kabupaten']!.text = dusun['kabupaten'];
              _controllers['kode_pos']!.text = dusun['kode_pos'];
            });
          },
        );
      },
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
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 118, 187, 212),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 118, 187, 212),
                  offset: const Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 🔹 Tombol Back
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                const Spacer(), // biar teks di tengah
                // 🔹 Judul
                const Text(
                  "✏️ Input Data",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),

                const Spacer(), // biar teks tetap di tengah
                const SizedBox(width: 48), // supaya balance sama tombol back
              ],
            ),
          ),

          Expanded(
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: () {
                if (_formKeys[_currentStep].currentState!.validate()) {
                  if (_currentStep < 2) {
                    setState(() => _currentStep += 1);
                  } else {
                    _save();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("⚠️ Lengkapi field wajib di step ini"),
                    ),
                  );
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep -= 1);
                } else {
                  Navigator.pop(context);
                }
              },
              steps: [
                //STEP 1
                Step(
                  title: const Text("Data Diri"),
                  isActive: _currentStep >= 0,
                  content: Form(
                    key: _formKeys[0],
                    child: Column(
                      children: [
                        buildField("nisn"),
                        buildField("namaLengkap"),
                        buildDropdown(
                          label: "Jenis Kelamin",
                          value: _jenisKelamin,
                          items: ["Laki-laki", "Perempuan"],
                          onChanged: (v) => setState(() => _jenisKelamin = v),
                        ),
                        buildDropdown(
                          label: "Agama",
                          value: _agama,
                          items: [
                            "Islam",
                            "Kristen",
                            "Katolik",
                            "Hindu",
                            "Buddha",
                            "Konghucu",
                          ],
                          onChanged: (v) => setState(() => _agama = v),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _pickTanggalLahir,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: "Tanggal Lahir",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: const Color.fromARGB(
                                255,
                                118,
                                187,
                                212,
                              ),
                            ),
                            child: Text(
                              _tanggalLahir != null
                                  ? "${_tanggalLahir!.day}-${_tanggalLahir!.month}-${_tanggalLahir!.year}"
                                  : "Pilih tanggal",
                            ),
                          ),
                        ),
                        buildField("noHp", keyboard: TextInputType.phone),
                        buildField("nik"),
                      ],
                    ),
                  ),
                ),

                //STEP 2
                Step(
                  title: const Text("Alamat"),
                  isActive: _currentStep >= 1,
                  content: Form(
                    key: _formKeys[1],
                    child: Column(
                      children: [
                        buildField("alamatJalan"),
                        Row(
                          children: [
                            Expanded(child: buildField("rtRw")),
                            const SizedBox(width: 12),
                            Expanded(child: buildDusunField()),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: buildField("desa")),
                            const SizedBox(width: 12),
                            Expanded(child: buildField("kecamatan")),
                          ],
                        ),
                        buildField("kabupaten"),
                        buildField("kode_pos", readOnly: true),
                      ],
                    ),
                  ),
                ),

                //STEP 3
                Step(
                  title: const Text("Orang Tua"),
                  isActive: _currentStep >= 2,
                  content: Form(
                    key: _formKeys[2],
                    child: Column(
                      children: [
                        buildField("namaAyah"),
                        buildField("namaIbu"),
                        buildField("namaWali"),
                        buildField("alamatOrangTua"),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _save,
                          icon: const Icon(Icons.save),
                          label: const Text("Simpan"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              118,
                              187,
                              212,
                            ),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
