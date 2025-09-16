import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Ambil ukuran layar
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 118, 187, 212),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height, // biar pas 1 layar
          width: width,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(width * 0.08), // padding responsif
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔹 Logo responsif
                  Image.asset(
                    "assets/images/logoo.png",
                    height: height * 0.2, // 20% tinggi layar
                  ),
                  SizedBox(height: height * 0.04),

                  // 🔹 Teks sambutan
                  Text(
                    "Selamat Datang di Aplikasi Data Siswa",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.06, // 6% lebar layar
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: height * 0.015),
                  Text(
                    "Kelola data siswa dengan lebih mudah dan cepat.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.04, // 4% lebar layar
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: height * 0.08),

                  // 🔹 Tombol Next responsif (full width)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor:
                            const Color.fromARGB(255, 118, 187, 212),
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.02, // 2% tinggi layar
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomePage()),
                        );
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontSize: width * 0.045, // 4.5% lebar layar
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
