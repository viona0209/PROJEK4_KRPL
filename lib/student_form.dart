import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/student_model.dart';
import 'services/student_service.dart';
import 'services/wilayah_service.dart';

class StudentForm extends StatefulWidget {
  final Student? student;
  final String? studentId;

  const StudentForm({super.key, this.student, this.studentId});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  int _currentStep = 0;
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // Controllers untuk semua field
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
      'tempat',
      'noHp',
      'nik',
      'alamatJalan',
      'rtRw',
      'dusun',
      'desa',
      'kecamatan',
      'kabupaten',
      'provinsi',
      'kode_pos',
      'namaAyah',
      'namaIbu',
      'alamatOrangTua',
      'namaWali',
    ];
    for (var f in fields) {
      _controllers[f] = TextEditingController(
        text: widget.student != null ? widget.student!.toJson()[f] ?? '' : '',
      );
    }

    _controllers['tempat'] = TextEditingController(
      text: widget.student != null ? widget.student!.tempat : '',
    );
    
    _jenisKelamin = widget.student?.jenisKelamin;
    _agama = widget.student?.agama;
    if (widget.student?.tanggalLahir != null)
      _tanggalLahir = widget.student!.tanggalLahir;
  }

  @override
  void dispose() {
    for (var c in _controllers.values) c.dispose();
    super.dispose();
  }

  //PILIH TANGGAL LAHIR
  void _pickTanggalLahir() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime(now.year - 16),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked != null) setState(() => _tanggalLahir = picked);
  }

  //SIMPAN DATA
  Future<void> _save() async {
    if (_tanggalLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Tanggal lahir wajib diisi")),
      );
      return;
    }

    final student = Student(
      nisn: _controllers['nisn']!.text,
      namaLengkap: _controllers['namaLengkap']!.text,
      jenisKelamin: _jenisKelamin ?? '',
      agama: _agama ?? '',
      tempatTanggalLahir:
          "${_controllers['tempat']?.text}, ${_tanggalLahir!.toIso8601String()}",
      noHp: _controllers['noHp']!.text,
      nik: _controllers['nik']!.text,
      alamatJalan: _controllers['alamatJalan']!.text,
      rtRw: _controllers['rtRw']!.text,
      dusun: _controllers['dusun']!.text,
      desa: _controllers['desa']!.text,
      kecamatan: _controllers['kecamatan']!.text,
      kabupaten: _controllers['kabupaten']!.text,
      provinsi: _controllers['provinsi']!.text,
      kodePos: _controllers['kode_pos']!.text,
      tanggalLahir: _tanggalLahir,
    );

    final parent = Parent(
      namaAyah: _controllers['namaAyah']!.text,
      namaIbu: _controllers['namaIbu']!.text,
      alamatOrangTua: _controllers['alamatOrangTua']!.text,
    );

    final guardian = Guardian(namaWali: _controllers['namaWali']!.text);

    try {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Konfirmasi"),
          content: Text(
            widget.studentId == null
                ? "Simpan data siswa?"
                : "Update data siswa ini?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Ya"),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      if (widget.studentId == null) {
        await StudentService.addStudentFull(
          student: student,
          parent: parent,
          guardian: guardian,
        );
      } else {
        await StudentService.updateStudentFull(
          studentId: widget.studentId!,
          student: student,
          parent: parent,
          guardian: guardian,
        );
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

  //WIDGET INPUT DENGAN VALIDASINYA
  Widget buildField(
    String key, {
    String? hint,
    TextInputType? keyboard,
    bool readOnly = false,
    bool requiredField = false,
    int? minLength,
    int? maxLength,
    bool numericOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: _controllers[key],
        keyboardType: keyboard,
        readOnly: readOnly,
        validator: (value) {
          value = value?.trim();
          if (requiredField && (value == null || value.isEmpty)) {
            return "⚠️ $key wajib diisi";
          }
          if (minLength != null && value != null && value.length < minLength) {
            return "⚠️ $key minimal $minLength karakter";
          }
          if (maxLength != null && value != null && value.length > maxLength) {
            return "⚠️ $key maksimal $maxLength karakter";
          }
          if (numericOnly &&
              value != null &&
              !RegExp(r'^\d+$').hasMatch(value)) {
            return "⚠️ $key hanya boleh angka";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: key,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: const Color.fromARGB(255, 118, 187, 212),
        ),
      ),
    );
  }

  //WIDGET DROPDOWN DENGAN VALIDASINYA
  Widget buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    bool requiredField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: (v) {
          if (requiredField && (v == null || v.isEmpty)) {
            return "⚠️ $label wajib dipilih";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: const Color.fromARGB(255, 118, 187, 212),
        ),
      ),
    );
  }

  //WIDGET DUSUN DENGAN AUTOCOMPLETE
  Widget buildDusunField() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: WilayahService.fetchDusun(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final dusunList = snapshot.data!;
        return Autocomplete<Map<String, dynamic>>(
          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text == '')
              return const Iterable<Map<String, dynamic>>.empty();
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
            );
          },
          onSelected: (dusun) {
            setState(() {
              _controllers['dusun']!.text = dusun['dusun'];
              _controllers['desa']!.text = dusun['desa'];
              _controllers['kecamatan']!.text = dusun['kecamatan'];
              _controllers['kabupaten']!.text = dusun['kabupaten'];
              _controllers['provinsi']?.text = dusun['provinsi'];
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
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                const Text(
                  "✏️ Input Data",
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
          //STEPER
          Expanded(
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: () {
                if (_formKeys[_currentStep].currentState!.validate()) {
                  if (_currentStep < 2)
                    setState(() => _currentStep++);
                  else
                    _save();
                }
              },
              onStepCancel: () {
                if (_currentStep > 0)
                  setState(() => _currentStep--);
                else
                  Navigator.pop(context);
              },
              steps: [
                Step(
                  title: const Text("Data Diri"),
                  isActive: _currentStep >= 0,
                  content: Form(
                    key: _formKeys[0],
                    child: Column(
                      children: [
                        buildField(
                          "nisn",
                          keyboard: TextInputType.number,
                          requiredField: true,
                          minLength: 10,
                          maxLength: 10,
                          numericOnly: true,
                        ),
                        buildField("namaLengkap", requiredField: true),
                        Row(
                          children: [
                            Expanded(
                              child: buildDropdown(
                                label: "Jenis Kelamin",
                                value: _jenisKelamin,
                                items: ["Laki-laki", "Perempuan"],
                                onChanged: (v) =>
                                    setState(() => _jenisKelamin = v),
                                requiredField: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: buildDropdown(
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
                                requiredField: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: buildField(
                                "tempat",
                                hint: "Tempat Lahir",
                                requiredField: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: InkWell(
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
                            ),
                          ],
                        ),
                        buildField(
                          "noHp",
                          keyboard: TextInputType.phone,
                          requiredField: true,
                          minLength: 12,
                          maxLength: 15,
                          numericOnly: true,
                        ),
                        buildField(
                          "nik",
                          keyboard: TextInputType.number,
                          requiredField: true,
                          minLength: 16,
                          maxLength: 16,
                          numericOnly: true,
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  title: const Text("Alamat"),
                  isActive: _currentStep >= 1,
                  content: Form(
                    key: _formKeys[1],
                    child: Column(
                      children: [
                        buildField("alamatJalan", requiredField: true),
                        Row(
                          children: [
                            Expanded(
                              child: buildField(
                                "rtRw",
                                requiredField: true,
                                numericOnly: true,
                              ),
                            ),
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
                        Row(
                          children: [
                            Expanded(child: buildField("kabupaten")),
                            const SizedBox(width: 12),
                            Expanded(child: buildField("provinsi")),
                          ],
                        ),
                        buildField("kode_pos", readOnly: true),
                      ],
                    ),
                  ),
                ),
                Step(
                  title: const Text("Orang Tua"),
                  isActive: _currentStep >= 2,
                  content: Form(
                    key: _formKeys[2],
                    child: Column(
                      children: [
                        buildField("namaAyah", requiredField: true),
                        buildField("namaIbu", requiredField: true),
                        buildField("alamatOrangTua", requiredField: true),
                        buildField("namaWali"), // opsional
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

class RtRwInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll('/', '');
    if (text.length > 4) text = text.substring(0, 4);
    if (text.length > 2) {
      text = text.substring(0, 2) + '/' + text.substring(2);
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
