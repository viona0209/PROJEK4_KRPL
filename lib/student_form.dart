import 'package:flutter/material.dart';
import 'models/student_model.dart';
import 'student_service.dart';

class StudentForm extends StatefulWidget {
  final Student? student;
  final int? index;

  const StudentForm({super.key, this.student, this.index});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  final Map<String, TextEditingController> _controllers = {};
  String? _jenisKelamin;
  String? _agama;
  DateTime? _tanggalLahir;

  @override
  void initState() {
    super.initState();
    final fields = [
      'nisn','namaLengkap','noHp','nik',
      'alamatJalan','rtRw','dusun','desa','kecamatan','kabupaten','provinsi','kodePos',
      'namaAyah','namaIbu','namaWali','alamatOrangTua',
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

  void _save() {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        nisn: _controllers['nisn']!.text,
        namaLengkap: _controllers['namaLengkap']!.text,
        jenisKelamin: _jenisKelamin ?? '',
        agama: _agama ?? '',
        tempatTanggalLahir:
            _tanggalLahir != null ? _tanggalLahir!.toIso8601String() : '',
        noHp: _controllers['noHp']!.text,
        nik: _controllers['nik']!.text,
        alamatJalan: _controllers['alamatJalan']!.text,
        rtRw: _controllers['rtRw']!.text,
        dusun: _controllers['dusun']!.text,
        desa: _controllers['desa']!.text,
        kecamatan: _controllers['kecamatan']!.text,
        kabupaten: _controllers['kabupaten']!.text,
        provinsi: _controllers['provinsi']!.text,
        kodePos: _controllers['kodePos']!.text,
        namaAyah: _controllers['namaAyah']!.text,
        namaIbu: _controllers['namaIbu']!.text,
        namaWali: _controllers['namaWali']!.text,
        alamatOrangTua: _controllers['alamatOrangTua']!.text,
      );

      if (widget.index == null) {
        StudentService.addStudent(student);
      } else {
        StudentService.updateStudent(widget.index!, student);
      }

      Navigator.pop(context);
    }
  }

  Widget buildField(String key, {String? hint, TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: _controllers[key],
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: key,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 118, 187, 212),
        ),
        validator: (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 118, 187, 212),
        ),
        validator: (v) => v == null ? "Wajib dipilih" : null,
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
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 118, 187, 212),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 118, 187, 212),
                  offset: const Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "✏️ Input Data",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep < 2) {
                    setState(() => _currentStep += 1);
                  } else {
                    _save();
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
                  Step(
                    title: const Text("Data Diri"),
                    isActive: _currentStep >= 0,
                    content: Column(
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
                          items: ["Islam", "Kristen", "Katolik", "Hindu", "Buddha", "Konghucu"],
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
                              fillColor: Color.fromARGB(255, 118, 187, 212),
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
                  Step(
                    title: const Text("Alamat"),
                    isActive: _currentStep >= 1,
                    content: Column(
                      children: [
                        buildField("alamatJalan"),
                        Row(
                          children: [
                            Expanded(child: buildField("rtRw")),
                            const SizedBox(width: 12),
                            Expanded(child: buildField("dusun")),
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
                        Row(
                          children: [
                            Expanded(child: buildField("provinsi")),
                            const SizedBox(width: 12),
                            Expanded(child: buildField("kodePos")),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text("Orang Tua"),
                    isActive: _currentStep >= 2,
                    content: Column(
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
                            backgroundColor: Color.fromARGB(255, 118, 187, 212),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
