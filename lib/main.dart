import 'package:flutter/material.dart';
import 'package:projek_4/splash_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // INISIALISASI SUPABASE
  await Supabase.initialize(
    url: 'https://xxhezwikbojldfknaqzv.supabase.co', //URL SUPABASE
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4aGV6d2lrYm9qbGRma25hcXp2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5ODY2NTgsImV4cCI6MjA3MzU2MjY1OH0.kxfOX3qtIcfBjR1ZfNoX0rzL9yJpNHKOPTeW7XBXezI', // 🔑 Anon Key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Input Data',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 81, 173, 206),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const SplashPage(),
    );
  }
}
